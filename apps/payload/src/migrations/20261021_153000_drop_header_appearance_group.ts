import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

/* Ручная миграция (migrate:create зависает на интерактивном вопросе drizzle
   про переименования энумов — см. 20261021_130800_seo_plugin_meta_group):
   группа appearance выведена из global «header» — оформление шапки теперь
   зашито в CSS-токены фронтенда (tokens.css, AppHeader.vue), а не в CMS. */
export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
  ALTER TABLE "header" DROP COLUMN "appearance_background_color";
  ALTER TABLE "header" DROP COLUMN "appearance_text_color";
  ALTER TABLE "header" DROP COLUMN "appearance_muted_text_color";
  ALTER TABLE "header" DROP COLUMN "appearance_accent_color";
  ALTER TABLE "header" DROP COLUMN "appearance_accent_text_color";
  ALTER TABLE "header" DROP COLUMN "appearance_font_family";
  ALTER TABLE "header" DROP COLUMN "appearance_brand_px";
  ALTER TABLE "header" DROP COLUMN "appearance_navigation_px";
  ALTER TABLE "header" DROP COLUMN "appearance_button_text_px";
  ALTER TABLE "header" DROP COLUMN "appearance_button_height_px";
  ALTER TABLE "header" DROP COLUMN "appearance_button_padding_x_px";
  ALTER TABLE "header" DROP COLUMN "appearance_button_radius_px";
  ALTER TABLE "header" DROP COLUMN "appearance_header_height_px";
  DROP TYPE "public"."enum_header_appearance_font_family";`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
  CREATE TYPE "public"."enum_header_appearance_font_family" AS ENUM('inter', 'manrope', 'system');
  ALTER TABLE "header" ADD COLUMN "appearance_background_color" varchar DEFAULT '#F8F7F3';
  ALTER TABLE "header" ADD COLUMN "appearance_text_color" varchar DEFAULT '#080808';
  ALTER TABLE "header" ADD COLUMN "appearance_muted_text_color" varchar DEFAULT '#303030';
  ALTER TABLE "header" ADD COLUMN "appearance_accent_color" varchar DEFAULT '#D7EF28';
  ALTER TABLE "header" ADD COLUMN "appearance_accent_text_color" varchar DEFAULT '#080808';
  ALTER TABLE "header" ADD COLUMN "appearance_font_family" "enum_header_appearance_font_family" DEFAULT 'inter';
  ALTER TABLE "header" ADD COLUMN "appearance_brand_px" numeric DEFAULT 30 NOT NULL;
  ALTER TABLE "header" ADD COLUMN "appearance_navigation_px" numeric DEFAULT 16 NOT NULL;
  ALTER TABLE "header" ADD COLUMN "appearance_button_text_px" numeric DEFAULT 18 NOT NULL;
  ALTER TABLE "header" ADD COLUMN "appearance_button_height_px" numeric DEFAULT 56 NOT NULL;
  ALTER TABLE "header" ADD COLUMN "appearance_button_padding_x_px" numeric DEFAULT 28 NOT NULL;
  ALTER TABLE "header" ADD COLUMN "appearance_button_radius_px" numeric DEFAULT 0 NOT NULL;
  ALTER TABLE "header" ADD COLUMN "appearance_header_height_px" numeric DEFAULT 88 NOT NULL;`)
}
