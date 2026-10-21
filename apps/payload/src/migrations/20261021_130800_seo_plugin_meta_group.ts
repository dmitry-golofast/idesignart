import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

/* Ручная миграция (migrate:create завис на интерактивном вопросе drizzle про
   переименования энумов): самописные seo-группы заменены плагином
   @payloadcms/plugin-seo. Сохраняет контент — колонки переименовываются
   (RENAME), а не пересоздаются:
   - seo.title/description/ogImage → meta.title/description/image (4 коллекции)
   - seo.noindex → meta.noindex (pages, posts; в projects/services поле новое)
   - seo.keywords — удалён (в плагине поля нет, мета-keywords поисковики
     игнорируют)
   - projects: группа параметров meta.* → details.* (имя meta занял плагин)
   Названия индексов/констрейнтов переименованы под драконью схему fresh-сборки,
   чтобы следующий автодифф не выдал лишних drop/create. */

export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
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
  ALTER INDEX "public"."_posts_v_version_seo_version_seo_og_image_idx" RENAME TO "_posts_v_version_meta_image_idx";`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
  ALTER INDEX "public"."pages_meta_image_idx" RENAME TO "pages_seo_seo_og_image_idx";
  ALTER INDEX "public"."_pages_v_version_meta_image_idx" RENAME TO "_pages_v_version_seo_version_seo_og_image_idx";
  ALTER INDEX "public"."projects_meta_image_idx" RENAME TO "projects_seo_seo_og_image_idx";
  ALTER INDEX "public"."_projects_v_version_meta_image_idx" RENAME TO "_projects_v_version_seo_version_seo_og_image_idx";
  ALTER INDEX "public"."services_meta_image_idx" RENAME TO "services_seo_seo_og_image_idx";
  ALTER INDEX "public"."_services_v_version_meta_image_idx" RENAME TO "_services_v_version_seo_version_seo_og_image_idx";
  ALTER INDEX "public"."posts_meta_image_idx" RENAME TO "posts_seo_seo_og_image_idx";
  ALTER INDEX "public"."_posts_v_version_meta_image_idx" RENAME TO "_posts_v_version_seo_version_seo_og_image_idx";

  ALTER TABLE "pages" RENAME CONSTRAINT "pages_meta_image_id_media_id_fk" TO "pages_seo_og_image_id_media_id_fk";
  ALTER TABLE "_pages_v" RENAME CONSTRAINT "_pages_v_version_meta_image_id_media_id_fk" TO "_pages_v_version_seo_og_image_id_media_id_fk";
  ALTER TABLE "projects" RENAME CONSTRAINT "projects_meta_image_id_media_id_fk" TO "projects_seo_og_image_id_media_id_fk";
  ALTER TABLE "_projects_v" RENAME CONSTRAINT "_projects_v_version_meta_image_id_media_id_fk" TO "_projects_v_version_seo_og_image_id_media_id_fk";
  ALTER TABLE "services" RENAME CONSTRAINT "services_meta_image_id_media_id_fk" TO "services_seo_og_image_id_media_id_fk";
  ALTER TABLE "_services_v" RENAME CONSTRAINT "_services_v_version_meta_image_id_media_id_fk" TO "_services_v_version_seo_og_image_id_media_id_fk";
  ALTER TABLE "posts" RENAME CONSTRAINT "posts_meta_image_id_media_id_fk" TO "posts_seo_og_image_id_media_id_fk";
  ALTER TABLE "_posts_v" RENAME CONSTRAINT "_posts_v_version_meta_image_id_media_id_fk" TO "_posts_v_version_seo_og_image_id_media_id_fk";

  ALTER TABLE "services" DROP COLUMN "meta_noindex";
  ALTER TABLE "services" RENAME COLUMN "meta_title" TO "seo_title";
  ALTER TABLE "services" RENAME COLUMN "meta_description" TO "seo_description";
  ALTER TABLE "services" RENAME COLUMN "meta_image_id" TO "seo_og_image_id";
  ALTER TABLE "services" ADD COLUMN "seo_keywords" varchar;
  ALTER TABLE "_services_v" DROP COLUMN "version_meta_noindex";
  ALTER TABLE "_services_v" RENAME COLUMN "version_meta_title" TO "version_seo_title";
  ALTER TABLE "_services_v" RENAME COLUMN "version_meta_description" TO "version_seo_description";
  ALTER TABLE "_services_v" RENAME COLUMN "version_meta_image_id" TO "version_seo_og_image_id";
  ALTER TABLE "_services_v" ADD COLUMN "version_seo_keywords" varchar;

  ALTER TABLE "projects" DROP COLUMN "meta_noindex";
  ALTER TABLE "projects" RENAME COLUMN "meta_title" TO "seo_title";
  ALTER TABLE "projects" RENAME COLUMN "meta_description" TO "seo_description";
  ALTER TABLE "projects" RENAME COLUMN "meta_image_id" TO "seo_og_image_id";
  ALTER TABLE "projects" ADD COLUMN "seo_keywords" varchar;
  ALTER TABLE "_projects_v" DROP COLUMN "version_meta_noindex";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_meta_title" TO "version_seo_title";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_meta_description" TO "version_seo_description";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_meta_image_id" TO "version_seo_og_image_id";
  ALTER TABLE "_projects_v" ADD COLUMN "version_seo_keywords" varchar;
  ALTER TABLE "projects" RENAME COLUMN "details_area" TO "meta_area";
  ALTER TABLE "projects" RENAME COLUMN "details_property_type" TO "meta_property_type";
  ALTER TABLE "projects" RENAME COLUMN "details_style" TO "meta_style";
  ALTER TABLE "projects" RENAME COLUMN "details_location" TO "meta_location";
  ALTER TABLE "projects" RENAME COLUMN "details_year" TO "meta_year";
  ALTER TABLE "projects" RENAME COLUMN "details_duration" TO "meta_duration";
  ALTER TABLE "projects" RENAME COLUMN "details_budget_range" TO "meta_budget_range";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_details_area" TO "version_meta_area";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_details_property_type" TO "version_meta_property_type";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_details_style" TO "version_meta_style";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_details_location" TO "version_meta_location";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_details_year" TO "version_meta_year";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_details_duration" TO "version_meta_duration";
  ALTER TABLE "_projects_v" RENAME COLUMN "version_details_budget_range" TO "version_meta_budget_range";

  ALTER TABLE "posts" RENAME COLUMN "meta_title" TO "seo_title";
  ALTER TABLE "posts" RENAME COLUMN "meta_description" TO "seo_description";
  ALTER TABLE "posts" RENAME COLUMN "meta_image_id" TO "seo_og_image_id";
  ALTER TABLE "posts" RENAME COLUMN "meta_noindex" TO "seo_noindex";
  ALTER TABLE "posts" ADD COLUMN "seo_keywords" varchar;
  ALTER TABLE "_posts_v" RENAME COLUMN "version_meta_title" TO "version_seo_title";
  ALTER TABLE "_posts_v" RENAME COLUMN "version_meta_description" TO "version_seo_description";
  ALTER TABLE "_posts_v" RENAME COLUMN "version_meta_image_id" TO "version_seo_og_image_id";
  ALTER TABLE "_posts_v" RENAME COLUMN "version_meta_noindex" TO "version_seo_noindex";
  ALTER TABLE "_posts_v" ADD COLUMN "version_seo_keywords" varchar;

  ALTER TABLE "pages" RENAME COLUMN "meta_title" TO "seo_title";
  ALTER TABLE "pages" RENAME COLUMN "meta_description" TO "seo_description";
  ALTER TABLE "pages" RENAME COLUMN "meta_image_id" TO "seo_og_image_id";
  ALTER TABLE "pages" RENAME COLUMN "meta_noindex" TO "seo_noindex";
  ALTER TABLE "pages" ADD COLUMN "seo_keywords" varchar;
  ALTER TABLE "_pages_v" RENAME COLUMN "version_meta_title" TO "version_seo_title";
  ALTER TABLE "_pages_v" RENAME COLUMN "version_meta_description" TO "version_seo_description";
  ALTER TABLE "_pages_v" RENAME COLUMN "version_meta_image_id" TO "version_seo_og_image_id";
  ALTER TABLE "_pages_v" RENAME COLUMN "version_meta_noindex" TO "version_seo_noindex";
  ALTER TABLE "_pages_v" ADD COLUMN "version_seo_keywords" varchar;

  ALTER TYPE "public"."enum__projects_v_version_details_property_type" RENAME TO "enum__projects_v_version_meta_property_type";
  ALTER TYPE "public"."enum__projects_v_version_details_style" RENAME TO "enum__projects_v_version_meta_style";
  ALTER TYPE "public"."enum__projects_v_version_details_budget_range" RENAME TO "enum__projects_v_version_meta_budget_range";
  ALTER TYPE "public"."enum_projects_details_property_type" RENAME TO "enum_projects_meta_property_type";
  ALTER TYPE "public"."enum_projects_details_style" RENAME TO "enum_projects_meta_style";
  ALTER TYPE "public"."enum_projects_details_budget_range" RENAME TO "enum_projects_meta_budget_range";`)
}
