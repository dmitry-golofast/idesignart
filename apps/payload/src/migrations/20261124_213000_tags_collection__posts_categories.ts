import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

/* Ручная миграция (migrate:create зависает на интерактивных вопросах drizzle —
   см. 20261021_130800_seo_plugin_meta_group): теги статей вынесены в отдельную
   коллекцию tags, а одиночная связь поста category стала hasMany categories
   (те же категории, что у портфолио). Контент сохраняется:
   - posts.category_id и _posts_v.version_category_id (одиночная связь
     хранится колонкой на самой таблице) → строки posts_rels / _posts_v_rels
     с path = 'categories'; колонки затем убираются
   - старые теги (path = 'tags', смотрели в categories) → одноимённые записи
     в tags, связи перелинковываются на tags_id
   Схема сверена с dev-базой, собранной drizzle push.
   Вся up-миграция — один блок sql: scripts/build-migration-delta.mjs берёт из
   файла только первый шаблонный литерал. */
export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
  CREATE TABLE "tags" (
    "id" serial PRIMARY KEY NOT NULL,
    "title" varchar NOT NULL,
    "slug" varchar NOT NULL,
    "updated_at" timestamp(3) with time zone DEFAULT now() NOT NULL,
    "created_at" timestamp(3) with time zone DEFAULT now() NOT NULL
  );
  CREATE UNIQUE INDEX "tags_slug_idx" ON "tags" USING btree ("slug");
  CREATE INDEX "tags_updated_at_idx" ON "tags" USING btree ("updated_at");
  CREATE INDEX "tags_created_at_idx" ON "tags" USING btree ("created_at");

  ALTER TABLE "posts_rels" ADD COLUMN "tags_id" integer;
  CREATE INDEX "posts_rels_tags_id_idx" ON "posts_rels" USING btree ("tags_id");
  ALTER TABLE "posts_rels" ADD CONSTRAINT "posts_rels_tags_fk" FOREIGN KEY ("tags_id") REFERENCES "public"."tags"("id") ON DELETE cascade ON UPDATE no action;

  ALTER TABLE "_posts_v_rels" ADD COLUMN "tags_id" integer;
  CREATE INDEX "_posts_v_rels_tags_id_idx" ON "_posts_v_rels" USING btree ("tags_id");
  ALTER TABLE "_posts_v_rels" ADD CONSTRAINT "_posts_v_rels_tags_fk" FOREIGN KEY ("tags_id") REFERENCES "public"."tags"("id") ON DELETE cascade ON UPDATE no action;

  ALTER TABLE "payload_locked_documents_rels" ADD COLUMN "tags_id" integer;
  CREATE INDEX "payload_locked_documents_rels_tags_id_idx" ON "payload_locked_documents_rels" USING btree ("tags_id");
  ALTER TABLE "payload_locked_documents_rels" ADD CONSTRAINT "payload_locked_documents_rels_tags_fk" FOREIGN KEY ("tags_id") REFERENCES "public"."tags"("id") ON DELETE cascade ON UPDATE no action;

  -- Категория поста: одиночная связь -> элемент hasMany categories.
  -- Сначала строки, оставшиеся под старым именем поля, затем значения из колонки
  UPDATE "posts_rels" SET "order" = COALESCE("order", 0), "path" = 'categories' WHERE "path" = 'category';
  INSERT INTO "posts_rels" ("order", "parent_id", "path", "categories_id")
    SELECT 0, p."id", 'categories', p."category_id" FROM "posts" p
    WHERE p."category_id" IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM "posts_rels" r WHERE r."parent_id" = p."id" AND r."path" = 'categories'
      );
  UPDATE "_posts_v_rels" SET "order" = COALESCE("order", 0), "path" = 'categories' WHERE "path" = 'category';
  INSERT INTO "_posts_v_rels" ("order", "parent_id", "path", "categories_id")
    SELECT 0, v."id", 'categories', v."version_category_id" FROM "_posts_v" v
    WHERE v."version_category_id" IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM "_posts_v_rels" r WHERE r."parent_id" = v."id" AND r."path" = 'categories'
      );
  DROP INDEX IF EXISTS "posts_category_idx";
  ALTER TABLE "posts" DROP CONSTRAINT IF EXISTS "posts_category_id_categories_id_fk";
  ALTER TABLE "posts" DROP COLUMN IF EXISTS "category_id";
  DROP INDEX IF EXISTS "_posts_v_version_version_category_idx";
  ALTER TABLE "_posts_v" DROP CONSTRAINT IF EXISTS "_posts_v_version_category_id_categories_id_fk";
  ALTER TABLE "_posts_v" DROP COLUMN IF EXISTS "version_category_id";

  -- Теги: раньше указывали на категории — пересоздаём одноимённые записи в tags
  -- и перелинковываем. Теги без связи со статьями не создаются
  INSERT INTO "tags" ("title", "slug", "updated_at", "created_at")
    SELECT DISTINCT c."title", c."slug", c."updated_at", c."created_at"
    FROM "categories" c
    WHERE EXISTS (SELECT 1 FROM "posts_rels" r WHERE r."path" = 'tags' AND r."categories_id" = c."id")
      OR EXISTS (SELECT 1 FROM "_posts_v_rels" v WHERE v."path" = 'tags' AND v."categories_id" = c."id")
    ON CONFLICT ("slug") DO NOTHING;
  UPDATE "posts_rels" r SET "tags_id" = t."id", "categories_id" = NULL
    FROM "categories" c
    JOIN "tags" t ON t."slug" = c."slug"
    WHERE r."path" = 'tags' AND r."categories_id" = c."id";
  UPDATE "_posts_v_rels" r SET "tags_id" = t."id", "categories_id" = NULL
    FROM "categories" c
    JOIN "tags" t ON t."slug" = c."slug"
    WHERE r."path" = 'tags' AND r."categories_id" = c."id";`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
  ALTER TABLE "posts" ADD COLUMN "category_id" integer;
  CREATE INDEX "posts_category_idx" ON "posts" USING btree ("category_id");
  ALTER TABLE "posts" ADD CONSTRAINT "posts_category_id_categories_id_fk" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "_posts_v" ADD COLUMN "version_category_id" integer;
  CREATE INDEX "_posts_v_version_version_category_idx" ON "_posts_v" USING btree ("version_category_id");
  ALTER TABLE "_posts_v" ADD CONSTRAINT "_posts_v_version_category_id_categories_id_fk" FOREIGN KEY ("version_category_id") REFERENCES "public"."categories"("id") ON DELETE set null ON UPDATE no action;

  -- Категория: первая из hasMany -> одиночная связь
  UPDATE "posts" p SET "category_id" = r."categories_id" FROM "posts_rels" r
    WHERE r."parent_id" = p."id" AND r."path" = 'categories' AND r."order" = 0;
  UPDATE "_posts_v" v SET "version_category_id" = r."categories_id" FROM "_posts_v_rels" r
    WHERE r."parent_id" = v."id" AND r."path" = 'categories' AND r."order" = 0;

  -- Теги: обратно в categories, пока у тега есть одноимённая категория
  -- (tags_id обнуляется — такие строки чистка ниже не трогает); остальные
  -- связи тегов удаляются — старой схемы для них нет
  UPDATE "posts_rels" r SET "categories_id" = c."id", "tags_id" = NULL
    FROM "tags" t
    JOIN "categories" c ON c."slug" = t."slug"
    WHERE r."path" = 'tags' AND r."tags_id" = t."id";
  UPDATE "_posts_v_rels" r SET "categories_id" = c."id", "tags_id" = NULL
    FROM "tags" t
    JOIN "categories" c ON c."slug" = t."slug"
    WHERE r."path" = 'tags' AND r."tags_id" = t."id";

  DELETE FROM "posts_rels" WHERE "path" = 'categories' OR "tags_id" IS NOT NULL;
  DELETE FROM "_posts_v_rels" WHERE "path" = 'categories' OR "tags_id" IS NOT NULL;
  DELETE FROM "payload_locked_documents_rels" WHERE "tags_id" IS NOT NULL;

  ALTER TABLE "posts_rels" DROP CONSTRAINT IF EXISTS "posts_rels_tags_fk";
  DROP INDEX IF EXISTS "posts_rels_tags_id_idx";
  ALTER TABLE "posts_rels" DROP COLUMN IF EXISTS "tags_id";
  ALTER TABLE "_posts_v_rels" DROP CONSTRAINT IF EXISTS "_posts_v_rels_tags_fk";
  DROP INDEX IF EXISTS "_posts_v_rels_tags_id_idx";
  ALTER TABLE "_posts_v_rels" DROP COLUMN IF EXISTS "tags_id";
  ALTER TABLE "payload_locked_documents_rels" DROP CONSTRAINT IF EXISTS "payload_locked_documents_rels_tags_fk";
  DROP INDEX IF EXISTS "payload_locked_documents_rels_tags_id_idx";
  ALTER TABLE "payload_locked_documents_rels" DROP COLUMN IF EXISTS "tags_id";

  DROP TABLE "tags";`)
}
