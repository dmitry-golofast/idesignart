-- Догон схемы БД: миграции 20261021_130800_seo_plugin_meta_group … 20261021_164000_settings_seo_plugin_meta.
-- Каждая миграция — в транзакции, как делает payload migrate.
-- Применение: docker exec -i idesignart-db psql -U postgres -d idesignart < apps/payload/migrations-delta.sql

-- ===== 20261021_130800_seo_plugin_meta_group.ts =====
BEGIN;
-- 1. Энумы projects: meta.* → details.*
  ALTER TYPE "public"."enum_projects_meta_property_type" RENAME TO "enum_projects_details_property_type";
  ALTER TYPE "public"."enum_projects_meta_style" RENAME TO "enum_projects_details_style";
  ALTER TYPE "public"."enum_projects_meta_budget_range" RENAME TO "enum_projects_details_budget_range";
  ALTER TYPE "public"."enum__projects_v_version_meta_property_type" RENAME TO "enum__projects_v_version_details_property_type";
  ALTER TYPE "public"."enum__projects_v_version_meta_style" RENAME TO "enum__projects_v_version_details_style";
  ALTER TYPE "public"."enum__projects_v_version_meta_budget_range" RENAME TO "enum__projects_v_version_details_budget_range";

  -- 2. pages / _pages_v: seo_* → meta_*
  ALTER TABLE "pages" RENAME COLUMN "seo_title" TO "meta_title";
  ALTER TABLE "pages" RENAME COLUMN "seo_description" TO "meta_description";
  ALTER TABLE "pages" RENAME COLUMN "seo_og_image_id" TO "meta_image_id";
  ALTER TABLE "pages" RENAME COLUMN "seo_noindex" TO "meta_noindex";
  ALTER TABLE "pages" DROP COLUMN "seo_keywords";
  ALTER TABLE "_pages_v" RENAME COLUMN "version_seo_title" TO "version_meta_title";
  ALTER TABLE "_pages_v" RENAME COLUMN "version_seo_description" TO "version_meta_description";
  ALTER TABLE "_pages_v" RENAME COLUMN "version_seo_og_image_id" TO "version_meta_image_id";
  ALTER TABLE "_pages_v" RENAME COLUMN "version_seo_noindex" TO "version_meta_noindex";
  ALTER TABLE "_pages_v" DROP COLUMN "version_seo_keywords";

  -- 3. posts / _posts_v
  ALTER TABLE "posts" RENAME COLUMN "seo_title" TO "meta_title";
  ALTER TABLE "posts" RENAME COLUMN "seo_description" TO "meta_description";
  ALTER TABLE "posts" RENAME COLUMN "seo_og_image_id" TO "meta_image_id";
  ALTER TABLE "posts" RENAME COLUMN "seo_noindex" TO "meta_noindex";
  ALTER TABLE "posts" DROP COLUMN "seo_keywords";
  ALTER TABLE "_posts_v" RENAME COLUMN "version_seo_title" TO "version_meta_title";
  ALTER TABLE "_posts_v" RENAME COLUMN "version_seo_description" TO "version_meta_description";
  ALTER TABLE "_posts_v" RENAME COLUMN "version_seo_og_image_id" TO "version_meta_image_id";
  ALTER TABLE "_posts_v" RENAME COLUMN "version_seo_noindex" TO "version_meta_noindex";
  ALTER TABLE "_posts_v" DROP COLUMN "version_seo_keywords";

  -- 4. projects / _projects_v: seo_* → meta_* (+ новое meta_noindex),
  --    параметры проекта meta_* → details_*
  ALTER TABLE "projects" RENAME COLUMN "seo_title" TO "meta_title";
  ALTER TABLE "projects" RENAME COLUMN "seo_description" TO "meta_description";
  ALTER TABLE "projects" RENAME COLUMN "seo_og_image_id" TO "meta_image_id";
  ALTER TABLE "projects" DROP COLUMN "seo_keywords";
  ALTER TABLE "projects" ADD COLUMN "meta_noindex" boolean DEFAULT false;
  ALTER TABLE "_projects_v" RENAME COLUMN "version_seo_title" TO "version_meta_title";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_seo_description" TO "version_meta_description";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_seo_og_image_id" TO "version_meta_image_id";
  ALTER TABLE "_projects_v" DROP COLUMN "version_seo_keywords";
  ALTER TABLE "_projects_v" ADD COLUMN "version_meta_noindex" boolean DEFAULT false;
  ALTER TABLE "projects" RENAME COLUMN "meta_area" TO "details_area";
  ALTER TABLE "projects" RENAME COLUMN "meta_property_type" TO "details_property_type";
  ALTER TABLE "projects" RENAME COLUMN "meta_style" TO "details_style";
  ALTER TABLE "projects" RENAME COLUMN "meta_location" TO "details_location";
  ALTER TABLE "projects" RENAME COLUMN "meta_year" TO "details_year";
  ALTER TABLE "projects" RENAME COLUMN "meta_duration" TO "details_duration";
  ALTER TABLE "projects" RENAME COLUMN "meta_budget_range" TO "details_budget_range";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_meta_area" TO "version_details_area";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_meta_property_type" TO "version_details_property_type";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_meta_style" TO "version_details_style";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_meta_location" TO "version_details_location";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_meta_year" TO "version_details_year";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_meta_duration" TO "version_details_duration";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_meta_budget_range" TO "version_details_budget_range";

  -- 5. services / _services_v
  ALTER TABLE "services" RENAME COLUMN "seo_title" TO "meta_title";
  ALTER TABLE "services" RENAME COLUMN "seo_description" TO "meta_description";
  ALTER TABLE "services" RENAME COLUMN "seo_og_image_id" TO "meta_image_id";
  ALTER TABLE "services" DROP COLUMN "seo_keywords";
  ALTER TABLE "services" ADD COLUMN "meta_noindex" boolean DEFAULT false;
  ALTER TABLE "_services_v" RENAME COLUMN "version_seo_title" TO "version_meta_title";
  ALTER TABLE "_services_v" RENAME COLUMN "version_seo_description" TO "version_meta_description";
  ALTER TABLE "_services_v" RENAME COLUMN "version_seo_og_image_id" TO "version_meta_image_id";
  ALTER TABLE "_services_v" DROP COLUMN "version_seo_keywords";
  ALTER TABLE "_services_v" ADD COLUMN "version_meta_noindex" boolean DEFAULT false;

  -- 6. Констрейнты FK → имена fresh-схемы
  ALTER TABLE "pages" RENAME CONSTRAINT "pages_seo_og_image_id_media_id_fk" TO "pages_meta_image_id_media_id_fk";
  ALTER TABLE "_pages_v" RENAME CONSTRAINT "_pages_v_version_seo_og_image_id_media_id_fk" TO "_pages_v_version_meta_image_id_media_id_fk";
  ALTER TABLE "projects" RENAME CONSTRAINT "projects_seo_og_image_id_media_id_fk" TO "projects_meta_image_id_media_id_fk";
  ALTER TABLE "_projects_v" RENAME CONSTRAINT "_projects_v_version_seo_og_image_id_media_id_fk" TO "_projects_v_version_meta_image_id_media_id_fk";
  ALTER TABLE "services" RENAME CONSTRAINT "services_seo_og_image_id_media_id_fk" TO "services_meta_image_id_media_id_fk";
  ALTER TABLE "_services_v" RENAME CONSTRAINT "_services_v_version_seo_og_image_id_media_id_fk" TO "_services_v_version_meta_image_id_media_id_fk";
  ALTER TABLE "posts" RENAME CONSTRAINT "posts_seo_og_image_id_media_id_fk" TO "posts_meta_image_id_media_id_fk";
  ALTER TABLE "_posts_v" RENAME CONSTRAINT "_posts_v_version_seo_og_image_id_media_id_fk" TO "_posts_v_version_meta_image_id_media_id_fk";

  -- 7. Индексы → имена fresh-схемы
  ALTER INDEX "public"."pages_seo_seo_og_image_idx" RENAME TO "pages_meta_image_idx";
  ALTER INDEX "public"."_pages_v_version_seo_version_seo_og_image_idx" RENAME TO "_pages_v_version_meta_image_idx";
  ALTER INDEX "public"."projects_seo_seo_og_image_idx" RENAME TO "projects_meta_image_idx";
  ALTER INDEX "public"."_projects_v_version_seo_version_seo_og_image_idx" RENAME TO "_projects_v_version_meta_image_idx";
  ALTER INDEX "public"."services_seo_seo_og_image_idx" RENAME TO "services_meta_image_idx";
  ALTER INDEX "public"."_services_v_version_seo_version_seo_og_image_idx" RENAME TO "_services_v_version_meta_image_idx";
  ALTER INDEX "public"."posts_seo_seo_og_image_idx" RENAME TO "posts_meta_image_idx";
  ALTER INDEX "public"."_posts_v_version_seo_version_seo_og_image_idx" RENAME TO "_posts_v_version_meta_image_idx";
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261021_130800_seo_plugin_meta_group', 1, now(), now());
COMMIT;

-- ===== 20261021_153000_drop_header_appearance_group.ts =====
BEGIN;
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
  DROP TYPE "public"."enum_header_appearance_font_family";
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261021_153000_drop_header_appearance_group', 1, now(), now());
COMMIT;

-- ===== 20261021_155500_drop_header_phone.ts =====
BEGIN;
ALTER TABLE "header" DROP COLUMN "phone";
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261021_155500_drop_header_phone', 1, now(), now());
COMMIT;

-- ===== 20261021_161500_drop_settings_social_proof_lead_magnet.ts =====
BEGIN;
DROP TABLE "settings_social_proof_stats";
  DROP TABLE "settings_social_proof_press_logos";
  ALTER TABLE "settings" DROP COLUMN "lead_magnet_enabled";
  ALTER TABLE "settings" DROP COLUMN "lead_magnet_title";
  ALTER TABLE "settings" DROP COLUMN "lead_magnet_subtitle";
  ALTER TABLE "settings" DROP COLUMN "lead_magnet_guide_file_id";
  ALTER TABLE "settings" DROP COLUMN "lead_magnet_image_id";
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261021_161500_drop_settings_social_proof_lead_magnet', 1, now(), now());
COMMIT;

-- ===== 20261021_164000_settings_seo_plugin_meta.ts =====
BEGIN;
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
  ALTER TABLE "settings" DROP COLUMN "seo_defaults_default_og_image_id";
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261021_164000_settings_seo_plugin_meta', 1, now(), now());
COMMIT;
