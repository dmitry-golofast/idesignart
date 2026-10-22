import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

/* Ручная миграция (migrate:create зависает на интерактивных вопросах drizzle
   про переименования энумов — см. 20261021_164000): новый блок «about-hero»
   («О студии — шапка») в blocks-поле pages. Как и у остальных блоков —
   две таблицы: pages_blocks_about_hero (опубликованные) и
   _pages_v_blocks_about_hero (черновики/версии). */
export async function up({ db }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
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
  ALTER TABLE "_pages_v_blocks_about_hero" ADD CONSTRAINT "_pages_v_blocks_about_hero_photo_id_media_id_fk" FOREIGN KEY ("photo_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;`)
}

export async function down({ db }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
  DROP TABLE IF EXISTS "_pages_v_blocks_about_hero";
  DROP TABLE IF EXISTS "pages_blocks_about_hero";`)
}
