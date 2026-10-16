import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

/* Миграция добавлена вручную: поле bgImage в ServicesBlock попало в коммит
   ed60a43 без migrate:create — в dev схему собирал drizzle push, а на свежем
   проде миграции колонку bg_image_id не создавали (API pages падал 500). */
export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
  ALTER TABLE "pages_blocks_services_grid" ADD COLUMN "bg_image_id" integer;
  ALTER TABLE "_pages_v_blocks_services_grid" ADD COLUMN "bg_image_id" integer;
  CREATE INDEX "pages_blocks_services_grid_bg_image_idx" ON "pages_blocks_services_grid" USING btree ("bg_image_id");
  CREATE INDEX "_pages_v_blocks_services_grid_bg_image_idx" ON "_pages_v_blocks_services_grid" USING btree ("bg_image_id");
  ALTER TABLE "pages_blocks_services_grid" ADD CONSTRAINT "pages_blocks_services_grid_bg_image_id_media_id_fk" FOREIGN KEY ("bg_image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "_pages_v_blocks_services_grid" ADD CONSTRAINT "_pages_v_blocks_services_grid_bg_image_id_media_id_fk" FOREIGN KEY ("bg_image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
  ALTER TABLE "pages_blocks_services_grid" DROP CONSTRAINT IF EXISTS "pages_blocks_services_grid_bg_image_id_media_id_fk";
  ALTER TABLE "_pages_v_blocks_services_grid" DROP CONSTRAINT IF EXISTS "_pages_v_blocks_services_grid_bg_image_id_media_id_fk";
  DROP INDEX IF EXISTS "pages_blocks_services_grid_bg_image_idx";
  DROP INDEX IF EXISTS "_pages_v_blocks_services_grid_bg_image_idx";
  ALTER TABLE "pages_blocks_services_grid" DROP COLUMN IF EXISTS "bg_image_id";
  ALTER TABLE "_pages_v_blocks_services_grid" DROP COLUMN IF EXISTS "bg_image_id";`)
}
