-- Догон схемы БД: миграции 3–11 (для сервера, где payload_migrations = первые 2).
-- Каждая миграция — в транзакции, как делает payload migrate. Контент не затрагивается.
-- Применение: docker exec -i idesignart-db psql -U postgres -d idesignart < apps/payload/migrations-delta.sql

-- ===== 20261012_105926_portfolio_grid__drop_showAllButton.ts =====
BEGIN;
CREATE TYPE "public"."enum_pages_blocks_portfolio_grid_facts_icon" AS ENUM('layers', 'house', 'leaf', 'compass');
  CREATE TYPE "public"."enum__pages_v_blocks_portfolio_grid_facts_icon" AS ENUM('layers', 'house', 'leaf', 'compass');
  CREATE TABLE "pages_blocks_portfolio_grid_facts" (
  	"_order" integer NOT NULL,
  	"_parent_id" varchar NOT NULL,
  	"id" varchar PRIMARY KEY NOT NULL,
  	"icon" "enum_pages_blocks_portfolio_grid_facts_icon" DEFAULT 'layers',
  	"value" varchar,
  	"label" varchar
  );
  
  CREATE TABLE "_pages_v_blocks_portfolio_grid_facts" (
  	"_order" integer NOT NULL,
  	"_parent_id" integer NOT NULL,
  	"id" serial PRIMARY KEY NOT NULL,
  	"icon" "enum__pages_v_blocks_portfolio_grid_facts_icon" DEFAULT 'layers',
  	"value" varchar,
  	"label" varchar,
  	"_uuid" varchar
  );
  
  ALTER TABLE "pages_blocks_portfolio_grid" ALTER COLUMN "eyebrow" SET DEFAULT 'Портфолио';
  ALTER TABLE "_pages_v_blocks_portfolio_grid" ALTER COLUMN "eyebrow" SET DEFAULT 'Портфолио';
  ALTER TABLE "pages_blocks_portfolio_grid_facts" ADD CONSTRAINT "pages_blocks_portfolio_grid_facts_parent_id_fk" FOREIGN KEY ("_parent_id") REFERENCES "public"."pages_blocks_portfolio_grid"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "_pages_v_blocks_portfolio_grid_facts" ADD CONSTRAINT "_pages_v_blocks_portfolio_grid_facts_parent_id_fk" FOREIGN KEY ("_parent_id") REFERENCES "public"."_pages_v_blocks_portfolio_grid"("id") ON DELETE cascade ON UPDATE no action;
  CREATE INDEX "pages_blocks_portfolio_grid_facts_order_idx" ON "pages_blocks_portfolio_grid_facts" USING btree ("_order");
  CREATE INDEX "pages_blocks_portfolio_grid_facts_parent_id_idx" ON "pages_blocks_portfolio_grid_facts" USING btree ("_parent_id");
  CREATE INDEX "_pages_v_blocks_portfolio_grid_facts_order_idx" ON "_pages_v_blocks_portfolio_grid_facts" USING btree ("_order");
  CREATE INDEX "_pages_v_blocks_portfolio_grid_facts_parent_id_idx" ON "_pages_v_blocks_portfolio_grid_facts" USING btree ("_parent_id");
  ALTER TABLE "pages_blocks_portfolio_grid" DROP COLUMN "show_all_button";
  ALTER TABLE "_pages_v_blocks_portfolio_grid" DROP COLUMN "show_all_button";
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261012_105926_portfolio_grid__drop_showAllButton', 1, now(), now());
COMMIT;

-- ===== 20261012_105942_portfolio_grid__add_showFilters_and_facts_cards.ts =====
BEGIN;
ALTER TABLE "pages_blocks_portfolio_grid" ADD COLUMN "show_filters" boolean DEFAULT true;
  ALTER TABLE "_pages_v_blocks_portfolio_grid" ADD COLUMN "show_filters" boolean DEFAULT true;
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261012_105942_portfolio_grid__add_showFilters_and_facts_cards', 1, now(), now());
COMMIT;

-- ===== 20261012_121240_portfolio_block_manual_projects__categories_order.ts =====
BEGIN;
/* IF NOT EXISTS: начальная миграция (перегенерирована 20260922) уже
      создаёт enum с 'leaf', на свежей БД повторный ADD VALUE падал бы */
   ALTER TYPE "public"."enum_pages_blocks_portfolio_grid_facts_icon" ADD VALUE IF NOT EXISTS 'leaf' BEFORE 'compass';
  ALTER TYPE "public"."enum__pages_v_blocks_portfolio_grid_facts_icon" ADD VALUE IF NOT EXISTS 'leaf' BEFORE 'compass';
  CREATE TABLE "pages_rels" (
  	"id" serial PRIMARY KEY NOT NULL,
  	"order" integer,
  	"parent_id" integer NOT NULL,
  	"path" varchar NOT NULL,
  	"projects_id" integer
  );
  
  CREATE TABLE "_pages_v_rels" (
  	"id" serial PRIMARY KEY NOT NULL,
  	"order" integer,
  	"parent_id" integer NOT NULL,
  	"path" varchar NOT NULL,
  	"projects_id" integer
  );
  
  ALTER TABLE "categories" ADD COLUMN "order" numeric;
  ALTER TABLE "pages_rels" ADD CONSTRAINT "pages_rels_parent_fk" FOREIGN KEY ("parent_id") REFERENCES "public"."pages"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "pages_rels" ADD CONSTRAINT "pages_rels_projects_fk" FOREIGN KEY ("projects_id") REFERENCES "public"."projects"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "_pages_v_rels" ADD CONSTRAINT "_pages_v_rels_parent_fk" FOREIGN KEY ("parent_id") REFERENCES "public"."_pages_v"("id") ON DELETE cascade ON UPDATE no action;
  ALTER TABLE "_pages_v_rels" ADD CONSTRAINT "_pages_v_rels_projects_fk" FOREIGN KEY ("projects_id") REFERENCES "public"."projects"("id") ON DELETE cascade ON UPDATE no action;
  CREATE INDEX "pages_rels_order_idx" ON "pages_rels" USING btree ("order");
  CREATE INDEX "pages_rels_parent_idx" ON "pages_rels" USING btree ("parent_id");
  CREATE INDEX "pages_rels_path_idx" ON "pages_rels" USING btree ("path");
  CREATE INDEX "pages_rels_projects_id_idx" ON "pages_rels" USING btree ("projects_id");
  CREATE INDEX "_pages_v_rels_order_idx" ON "_pages_v_rels" USING btree ("order");
  CREATE INDEX "_pages_v_rels_parent_idx" ON "_pages_v_rels" USING btree ("parent_id");
  CREATE INDEX "_pages_v_rels_path_idx" ON "_pages_v_rels" USING btree ("path");
  CREATE INDEX "_pages_v_rels_projects_id_idx" ON "_pages_v_rels" USING btree ("projects_id");
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261012_121240_portfolio_block_manual_projects__categories_order', 1, now(), now());
COMMIT;

-- ===== 20261013_073214_drop_hero_appearance_group.ts =====
BEGIN;
ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_background_color";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_text_color";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_muted_text_color";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_accent_color";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_accent_text_color";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_divider_color";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_caption_color";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_font_family";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_title_weight";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_title_desktop_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_title_mobile_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_title_line_height";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_title_letter_spacing_em";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_body_desktop_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_body_mobile_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_body_line_height";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_brand_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_navigation_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_eyebrow_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_eyebrow_letter_spacing_em";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_caption_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_bottom_line_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_button_text_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_button_height_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_button_padding_x_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_button_radius_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_content_max_width_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_desktop_gutter_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_mobile_gutter_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_header_height_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_hero_top_padding_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_hero_bottom_padding_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_hero_column_gap_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_title_column_percent";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_description_button_gap_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_mobile_stack_gap_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_image_width";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_image_desktop_ratio";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_image_mobile_ratio";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_image_radius_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_caption_inset_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_bottom_line_padding_y_px";
  ALTER TABLE "pages_blocks_hero" DROP COLUMN "appearance_divider_thickness_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_background_color";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_text_color";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_muted_text_color";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_accent_color";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_accent_text_color";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_divider_color";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_caption_color";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_font_family";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_title_weight";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_title_desktop_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_title_mobile_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_title_line_height";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_title_letter_spacing_em";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_body_desktop_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_body_mobile_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_body_line_height";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_brand_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_navigation_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_eyebrow_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_eyebrow_letter_spacing_em";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_caption_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_bottom_line_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_button_text_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_button_height_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_button_padding_x_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_button_radius_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_content_max_width_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_desktop_gutter_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_mobile_gutter_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_header_height_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_hero_top_padding_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_hero_bottom_padding_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_hero_column_gap_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_title_column_percent";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_description_button_gap_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_mobile_stack_gap_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_image_width";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_image_desktop_ratio";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_image_mobile_ratio";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_image_radius_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_caption_inset_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_bottom_line_padding_y_px";
  ALTER TABLE "_pages_v_blocks_hero" DROP COLUMN "appearance_divider_thickness_px";
  DROP TYPE "public"."enum_pages_blocks_hero_appearance_font_family";
  DROP TYPE "public"."enum_pages_blocks_hero_appearance_title_weight";
  DROP TYPE "public"."enum_pages_blocks_hero_appearance_image_width";
  DROP TYPE "public"."enum_pages_blocks_hero_appearance_image_desktop_ratio";
  DROP TYPE "public"."enum_pages_blocks_hero_appearance_image_mobile_ratio";
  DROP TYPE "public"."enum__pages_v_blocks_hero_appearance_font_family";
  DROP TYPE "public"."enum__pages_v_blocks_hero_appearance_title_weight";
  DROP TYPE "public"."enum__pages_v_blocks_hero_appearance_image_width";
  DROP TYPE "public"."enum__pages_v_blocks_hero_appearance_image_desktop_ratio";
  DROP TYPE "public"."enum__pages_v_blocks_hero_appearance_image_mobile_ratio";
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261013_073214_drop_hero_appearance_group', 1, now(), now());
COMMIT;

-- ===== 20261013_084339_stats_cards__add_icon_description_image.ts =====
BEGIN;
CREATE TYPE "public"."enum_pages_blocks_stats_items_icon" AS ENUM('layers', 'house', 'leaf', 'compass', 'heart', 'trending-up');
  CREATE TYPE "public"."enum__pages_v_blocks_stats_items_icon" AS ENUM('layers', 'house', 'leaf', 'compass', 'heart', 'trending-up');
  ALTER TABLE "pages_blocks_stats_items" ADD COLUMN "icon" "enum_pages_blocks_stats_items_icon" DEFAULT 'layers';
  ALTER TABLE "pages_blocks_stats_items" ADD COLUMN "description" varchar;
  ALTER TABLE "pages_blocks_stats_items" ADD COLUMN "image_id" integer;
  ALTER TABLE "_pages_v_blocks_stats_items" ADD COLUMN "icon" "enum__pages_v_blocks_stats_items_icon" DEFAULT 'layers';
  ALTER TABLE "_pages_v_blocks_stats_items" ADD COLUMN "description" varchar;
  ALTER TABLE "_pages_v_blocks_stats_items" ADD COLUMN "image_id" integer;
  ALTER TABLE "pages_blocks_stats_items" ADD CONSTRAINT "pages_blocks_stats_items_image_id_media_id_fk" FOREIGN KEY ("image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "_pages_v_blocks_stats_items" ADD CONSTRAINT "_pages_v_blocks_stats_items_image_id_media_id_fk" FOREIGN KEY ("image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  CREATE INDEX "pages_blocks_stats_items_image_idx" ON "pages_blocks_stats_items" USING btree ("image_id");
  CREATE INDEX "_pages_v_blocks_stats_items_image_idx" ON "_pages_v_blocks_stats_items" USING btree ("image_id");
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261013_084339_stats_cards__add_icon_description_image', 1, now(), now());
COMMIT;

-- ===== 20261013_102414_services__add_cardImage_and_tagline.ts =====
BEGIN;
ALTER TABLE "pages_blocks_services_grid" ALTER COLUMN "title" SET DEFAULT 'Чем мы можем помочь';
  ALTER TABLE "pages_blocks_services_grid" ALTER COLUMN "description" SET DEFAULT 'Полный цикл: от планировки и визуализации до реализации под ключ.';
  ALTER TABLE "_pages_v_blocks_services_grid" ALTER COLUMN "title" SET DEFAULT 'Чем мы можем помочь';
  ALTER TABLE "_pages_v_blocks_services_grid" ALTER COLUMN "description" SET DEFAULT 'Полный цикл: от планировки и визуализации до реализации под ключ.';
  ALTER TABLE "services" ADD COLUMN "card_image_id" integer;
  ALTER TABLE "services" ADD COLUMN "tagline" varchar;
  ALTER TABLE "_services_v" ADD COLUMN "version_card_image_id" integer;
  ALTER TABLE "_services_v" ADD COLUMN "version_tagline" varchar;
  ALTER TABLE "services" ADD CONSTRAINT "services_card_image_id_media_id_fk" FOREIGN KEY ("card_image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "_services_v" ADD CONSTRAINT "_services_v_version_card_image_id_media_id_fk" FOREIGN KEY ("version_card_image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  CREATE INDEX "services_card_image_idx" ON "services" USING btree ("card_image_id");
  CREATE INDEX "_services_v_version_version_card_image_idx" ON "_services_v" USING btree ("version_card_image_id");
  ALTER TABLE "pages_blocks_services_grid" DROP COLUMN "eyebrow";
  ALTER TABLE "_pages_v_blocks_services_grid" DROP COLUMN "eyebrow";
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261013_102414_services__add_cardImage_and_tagline', 1, now(), now());
COMMIT;

-- ===== 20261013_102429_services__drop_icon__replaced_by_cardImage_.ts =====
BEGIN;
ALTER TABLE "services" DROP CONSTRAINT "services_icon_id_media_id_fk";
  
  ALTER TABLE "_services_v" DROP CONSTRAINT "_services_v_version_icon_id_media_id_fk";
  
  DROP INDEX "services_icon_idx";
  DROP INDEX "_services_v_version_version_icon_idx";
  ALTER TABLE "services" DROP COLUMN "icon_id";
  ALTER TABLE "_services_v" DROP COLUMN "version_icon_id";
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261013_102429_services__drop_icon__replaced_by_cardImage_', 1, now(), now());
COMMIT;

-- ===== 20261013_124029_process_steps__add_description_and_sketch_fields.ts =====
BEGIN;
CREATE TYPE "public"."enum_pages_blocks_process_steps_steps_sketch" AS ENUM('plan', 'iso', 'elevation', 'perspective');
  CREATE TYPE "public"."enum__pages_v_blocks_process_steps_steps_sketch" AS ENUM('plan', 'iso', 'elevation', 'perspective');
  ALTER TABLE "pages_blocks_process_steps" ALTER COLUMN "eyebrow" SET DEFAULT 'Процесс';
  ALTER TABLE "pages_blocks_process_steps" ALTER COLUMN "title" SET DEFAULT 'Как мы работаем';
  ALTER TABLE "_pages_v_blocks_process_steps" ALTER COLUMN "eyebrow" SET DEFAULT 'Процесс';
  ALTER TABLE "_pages_v_blocks_process_steps" ALTER COLUMN "title" SET DEFAULT 'Как мы работаем';
  ALTER TABLE "pages_blocks_process_steps_steps" ADD COLUMN "sketch" "enum_pages_blocks_process_steps_steps_sketch" DEFAULT 'plan';
  ALTER TABLE "pages_blocks_process_steps" ADD COLUMN "description" varchar DEFAULT 'Четыре листа — от первой идеи до готового интерьера';
  ALTER TABLE "_pages_v_blocks_process_steps_steps" ADD COLUMN "sketch" "enum__pages_v_blocks_process_steps_steps_sketch" DEFAULT 'plan';
  ALTER TABLE "_pages_v_blocks_process_steps" ADD COLUMN "description" varchar DEFAULT 'Четыре листа — от первой идеи до готового интерьера';
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261013_124029_process_steps__add_description_and_sketch_fields', 1, now(), now());
COMMIT;

-- ===== 20261014_162547.ts =====
BEGIN;
ALTER TABLE "pages_blocks_process_steps_steps" ADD COLUMN "image_id" integer;
  ALTER TABLE "_pages_v_blocks_process_steps_steps" ADD COLUMN "image_id" integer;
  ALTER TABLE "pages_blocks_process_steps_steps" ADD CONSTRAINT "pages_blocks_process_steps_steps_image_id_media_id_fk" FOREIGN KEY ("image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "_pages_v_blocks_process_steps_steps" ADD CONSTRAINT "_pages_v_blocks_process_steps_steps_image_id_media_id_fk" FOREIGN KEY ("image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  CREATE INDEX "pages_blocks_process_steps_steps_image_idx" ON "pages_blocks_process_steps_steps" USING btree ("image_id");
  CREATE INDEX "_pages_v_blocks_process_steps_steps_image_idx" ON "_pages_v_blocks_process_steps_steps" USING btree ("image_id");
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261014_162547', 1, now(), now());
COMMIT;
