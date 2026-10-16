-- Ручное применение миграции 20261017_003000_services_block__add_bg_image
-- (для сервера, где CLI payload migrate зависает). Идемпотентность не нужна:
-- применяется один раз, на схеме после migrations-delta.sql.
--   docker exec -i idesignart-db psql -U postgres -d idesignart -v ON_ERROR_STOP=1 < apps/payload/migrations-fix-bg-image.sql
BEGIN;
ALTER TABLE "pages_blocks_services_grid" ADD COLUMN "bg_image_id" integer;
ALTER TABLE "_pages_v_blocks_services_grid" ADD COLUMN "bg_image_id" integer;
CREATE INDEX "pages_blocks_services_grid_bg_image_idx" ON "pages_blocks_services_grid" USING btree ("bg_image_id");
CREATE INDEX "_pages_v_blocks_services_grid_bg_image_idx" ON "_pages_v_blocks_services_grid" USING btree ("bg_image_id");
ALTER TABLE "pages_blocks_services_grid" ADD CONSTRAINT "pages_blocks_services_grid_bg_image_id_media_id_fk" FOREIGN KEY ("bg_image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
ALTER TABLE "_pages_v_blocks_services_grid" ADD CONSTRAINT "_pages_v_blocks_services_grid_bg_image_id_media_id_fk" FOREIGN KEY ("bg_image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('20261017_003000_services_block__add_bg_image', 1, now(), now());
COMMIT;
