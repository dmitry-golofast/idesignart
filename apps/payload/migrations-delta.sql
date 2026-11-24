-- Догон схемы БД: миграции 20261022_161500_add_about_hero_block … 20261124_213000_tags_collection__posts_categories.
-- Каждая миграция — в транзакции, как делает payload migrate.
-- Применение: docker exec -i idesignart-db psql -U postgres -d idesignart < apps/payload/migrations-delta.sql

-- ===== 20261022_161500_add_about_hero_block.ts =====
BEGIN;
CREATE TABLE "pages_blocks_about_hero" (
    "_order" integer NOT NULL,
    "_parent_id" integer NOT NULL,
    "_path" text NOT NULL,
    "id" varchar NOT NULL CONSTRAINT "pages_blocks_about_hero_pkey" PRIMARY KEY,
    "title" varchar DEFAULT 'Создаём пространства, в которых хочется жить и работать',
    "description" varchar DEFAULT 'idesignart — студия дизайна интерьера и 3D-визуализации. Мы проектируем квартиры, дома и общественные пространства, объединяя эстетику и функциональность.',
    "photo_id" integer,
    "photo_alt" varchar,
    "quote" varchar,
    "quote_author" varchar,
    "quote_role" varchar,
    "block_name" varchar
  );
  CREATE INDEX "pages_blocks_about_hero_order_idx" ON "pages_blocks_about_hero" USING btree ("_order");
  CREATE INDEX "pages_blocks_about_hero_parent_id_idx" ON "pages_blocks_about_hero" USING btree ("_parent_id");
  CREATE INDEX "pages_blocks_about_hero_path_idx" ON "pages_blocks_about_hero" USING btree ("_path");
  CREATE INDEX "pages_blocks_about_hero_photo_id_idx" ON "pages_blocks_about_hero" USING btree ("photo_id");
  ALTER TABLE "pages_blocks_about_hero" ADD CONSTRAINT "pages_blocks_about_hero_parent_id_fk" FOREIGN KEY ("_parent_id") REFERENCES "public"."pages"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "pages_blocks_about_hero" ADD CONSTRAINT "pages_blocks_about_hero_photo_id_media_id_fk" FOREIGN KEY ("photo_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;

  CREATE TABLE "_pages_v_blocks_about_hero" (
    "_order" integer NOT NULL,
    "_parent_id" integer NOT NULL,
    "_path" text NOT NULL,
    "id" serial CONSTRAINT "_pages_v_blocks_about_hero_pkey" PRIMARY KEY,
    "_uuid" varchar,
    "title" varchar DEFAULT 'Создаём пространства, в которых хочется жить и работать',
    "description" varchar DEFAULT 'idesignart — студия дизайна интерьера и 3D-визуализации. Мы проектируем квартиры, дома и общественные пространства, объединяя эстетику и функциональность.',
    "photo_id" integer,
    "photo_alt" varchar,
    "quote" varchar,
    "quote_author" varchar,
    "quote_role" varchar,
    "block_name" varchar
  );
  CREATE INDEX "_pages_v_blocks_about_hero_order_idx" ON "_pages_v_blocks_about_hero" USING btree ("_order");
  CREATE INDEX "_pages_v_blocks_about_hero_parent_id_idx" ON "_pages_v_blocks_about_hero" USING btree ("_parent_id");
  CREATE INDEX "_pages_v_blocks_about_hero_path_idx" ON "_pages_v_blocks_about_hero" USING btree ("_path");
  CREATE INDEX "_pages_v_blocks_about_hero_photo_id_idx" ON "_pages_v_blocks_about_hero" USING btree ("photo_id");
  ALTER TABLE "_pages_v_blocks_about_hero" ADD CONSTRAINT "_pages_v_blocks_about_hero_parent_id_fk" FOREIGN KEY ("_parent_id") REFERENCES "public"."_pages_v"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "_pages_v_blocks_about_hero" ADD CONSTRAINT "_pages_v_blocks_about_hero_photo_id_media_id_fk" FOREIGN KEY ("photo_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261022_161500_add_about_hero_block', 1, now(), now());
COMMIT;

-- ===== 20261124_213000_tags_collection__posts_categories.ts =====
BEGIN;
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
    WHERE r."path" = 'tags' AND r."categories_id" = c."id";
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261124_213000_tags_collection__posts_categories', 1, now(), now());
COMMIT;
