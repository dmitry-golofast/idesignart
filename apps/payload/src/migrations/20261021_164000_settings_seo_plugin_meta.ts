import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

/* Ручная миграция (migrate:create зависает на интерактивном вопросе drizzle
   про переименования энумов — см. 20261021_130800_seo_plugin_meta_group):
   seoPlugin теперь добавляет группу meta и в global «settings»
   (globals: ['settings']) — дефолтные title/description/OG-картинка сайта
   переезжают из ручной группы seoDefaults в meta плагина.
   Контент сохраняется: значения seoDefaults копируются в meta_* до дропа
   старых колонок. Коды верификации (google/yandex) остаются в seoDefaults —
   их колонки не трогаем. */
export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
  ALTER TABLE "settings" ADD COLUMN "meta_title" varchar;
  ALTER TABLE "settings" ADD COLUMN "meta_description" varchar;
  ALTER TABLE "settings" ADD COLUMN "meta_noindex" boolean DEFAULT false;
  ALTER TABLE "settings" ADD COLUMN "meta_image_id" integer;
  ALTER TABLE "settings" ADD CONSTRAINT "settings_meta_image_id_media_id_fk" FOREIGN KEY ("meta_image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  CREATE INDEX "settings_meta_image_idx" ON "settings" USING btree ("meta_image_id");
  UPDATE "settings" SET
    "meta_title" = "seo_defaults_title",
    "meta_description" = "seo_defaults_description_template",
    "meta_image_id" = "seo_defaults_default_og_image_id";
  ALTER TABLE "settings" DROP COLUMN "seo_defaults_title";
  ALTER TABLE "settings" DROP COLUMN "seo_defaults_description_template";
  ALTER TABLE "settings" DROP COLUMN "seo_defaults_default_og_image_id";`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
  ALTER TABLE "settings" ADD COLUMN "seo_defaults_title" varchar;
  ALTER TABLE "settings" ADD COLUMN "seo_defaults_description_template" varchar;
  ALTER TABLE "settings" ADD COLUMN "seo_defaults_default_og_image_id" integer;
  UPDATE "settings" SET
    "seo_defaults_title" = "meta_title",
    "seo_defaults_description_template" = "meta_description",
    "seo_defaults_default_og_image_id" = "meta_image_id";
  DROP INDEX IF EXISTS "settings_meta_image_idx";
  ALTER TABLE "settings" DROP CONSTRAINT IF EXISTS "settings_meta_image_id_media_id_fk";
  ALTER TABLE "settings" DROP COLUMN "meta_image_id";
  ALTER TABLE "settings" DROP COLUMN "meta_noindex";
  ALTER TABLE "settings" DROP COLUMN "meta_description";
  ALTER TABLE "settings" DROP COLUMN "meta_title";
  ALTER TABLE "settings" ADD CONSTRAINT "settings_seo_defaults_default_og_image_id_media_id_fk" FOREIGN KEY ("seo_defaults_default_og_image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;`)
}
