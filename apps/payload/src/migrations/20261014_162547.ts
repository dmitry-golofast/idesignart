import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
   ALTER TABLE "pages_blocks_process_steps_steps" ADD COLUMN "image_id" integer;
  ALTER TABLE "_pages_v_blocks_process_steps_steps" ADD COLUMN "image_id" integer;
  ALTER TABLE "pages_blocks_process_steps_steps" ADD CONSTRAINT "pages_blocks_process_steps_steps_image_id_media_id_fk" FOREIGN KEY ("image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "_pages_v_blocks_process_steps_steps" ADD CONSTRAINT "_pages_v_blocks_process_steps_steps_image_id_media_id_fk" FOREIGN KEY ("image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  CREATE INDEX "pages_blocks_process_steps_steps_image_idx" ON "pages_blocks_process_steps_steps" USING btree ("image_id");
  CREATE INDEX "_pages_v_blocks_process_steps_steps_image_idx" ON "_pages_v_blocks_process_steps_steps" USING btree ("image_id");`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
   ALTER TABLE "pages_blocks_process_steps_steps" DROP CONSTRAINT "pages_blocks_process_steps_steps_image_id_media_id_fk";
  
  ALTER TABLE "_pages_v_blocks_process_steps_steps" DROP CONSTRAINT "_pages_v_blocks_process_steps_steps_image_id_media_id_fk";
  
  DROP INDEX "pages_blocks_process_steps_steps_image_idx";
  DROP INDEX "_pages_v_blocks_process_steps_steps_image_idx";
  ALTER TABLE "pages_blocks_process_steps_steps" DROP COLUMN "image_id";
  ALTER TABLE "_pages_v_blocks_process_steps_steps" DROP COLUMN "image_id";`)
}
