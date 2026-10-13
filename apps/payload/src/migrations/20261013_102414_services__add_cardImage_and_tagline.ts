import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
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
  ALTER TABLE "_pages_v_blocks_services_grid" DROP COLUMN "eyebrow";`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
   ALTER TABLE "services" DROP CONSTRAINT "services_card_image_id_media_id_fk";
  
  ALTER TABLE "_services_v" DROP CONSTRAINT "_services_v_version_card_image_id_media_id_fk";
  
  DROP INDEX "services_card_image_idx";
  DROP INDEX "_services_v_version_version_card_image_idx";
  ALTER TABLE "pages_blocks_services_grid" ALTER COLUMN "title" SET DEFAULT 'Услуги';
  ALTER TABLE "pages_blocks_services_grid" ALTER COLUMN "description" DROP DEFAULT;
  ALTER TABLE "_pages_v_blocks_services_grid" ALTER COLUMN "title" SET DEFAULT 'Услуги';
  ALTER TABLE "_pages_v_blocks_services_grid" ALTER COLUMN "description" DROP DEFAULT;
  ALTER TABLE "pages_blocks_services_grid" ADD COLUMN "eyebrow" varchar DEFAULT 'Что мы делаем';
  ALTER TABLE "_pages_v_blocks_services_grid" ADD COLUMN "eyebrow" varchar DEFAULT 'Что мы делаем';
  ALTER TABLE "services" DROP COLUMN "card_image_id";
  ALTER TABLE "services" DROP COLUMN "tagline";
  ALTER TABLE "_services_v" DROP COLUMN "version_card_image_id";
  ALTER TABLE "_services_v" DROP COLUMN "version_tagline";`)
}
