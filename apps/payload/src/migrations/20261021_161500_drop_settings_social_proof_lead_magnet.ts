import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

/* Ручная миграция (migrate:create зависает на интерактивном вопросе drizzle
   про переименования энумов — см. 20261021_130800_seo_plugin_meta_group):
   группы socialProof и leadMagnet выведены из global «settings» — во
   фронтенде не использовались (LeadMagnet.vue нигде не смонтирован).
   DROP COLUMN сам уносит FK-констрейнты на media; DROP TABLE — индексы. */
export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
  DROP TABLE "settings_social_proof_stats";
  DROP TABLE "settings_social_proof_press_logos";
  ALTER TABLE "settings" DROP COLUMN "lead_magnet_enabled";
  ALTER TABLE "settings" DROP COLUMN "lead_magnet_title";
  ALTER TABLE "settings" DROP COLUMN "lead_magnet_subtitle";
  ALTER TABLE "settings" DROP COLUMN "lead_magnet_guide_file_id";
  ALTER TABLE "settings" DROP COLUMN "lead_magnet_image_id";`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
  CREATE TABLE "settings_social_proof_stats" (
  	"_order" integer NOT NULL,
  	"_parent_id" integer NOT NULL,
  	"id" varchar PRIMARY KEY NOT NULL,
  	"value" varchar NOT NULL,
  	"label" varchar NOT NULL
  );

  CREATE TABLE "settings_social_proof_press_logos" (
  	"_order" integer NOT NULL,
  	"_parent_id" integer NOT NULL,
  	"id" varchar PRIMARY KEY NOT NULL,
  	"name" varchar,
  	"logo_id" integer,
  	"url" varchar
  );

  ALTER TABLE "settings_social_proof_stats" ADD CONSTRAINT "settings_social_proof_stats_parent_id_fk" FOREIGN KEY ("_parent_id") REFERENCES "public"."settings"("id") ON DELETE cascade ON UPDATE no action;
  CREATE INDEX "settings_social_proof_stats_order_idx" ON "settings_social_proof_stats" USING btree ("_order");
  CREATE INDEX "settings_social_proof_stats_parent_id_idx" ON "settings_social_proof_stats" USING btree ("_parent_id");

  ALTER TABLE "settings_social_proof_press_logos" ADD CONSTRAINT "settings_social_proof_press_logos_logo_id_media_id_fk" FOREIGN KEY ("logo_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "settings_social_proof_press_logos" ADD CONSTRAINT "settings_social_proof_press_logos_parent_id_fk" FOREIGN KEY ("_parent_id") REFERENCES "public"."settings"("id") ON DELETE cascade ON UPDATE no action;
  CREATE INDEX "settings_social_proof_press_logos_order_idx" ON "settings_social_proof_press_logos" USING btree ("_order");
  CREATE INDEX "settings_social_proof_press_logos_parent_id_idx" ON "settings_social_proof_press_logos" USING btree ("_parent_id");
  CREATE INDEX "settings_social_proof_press_logos_logo_idx" ON "settings_social_proof_press_logos" USING btree ("logo_id");

  ALTER TABLE "settings" ADD COLUMN "lead_magnet_enabled" boolean DEFAULT true;
  ALTER TABLE "settings" ADD COLUMN "lead_magnet_title" varchar;
  ALTER TABLE "settings" ADD COLUMN "lead_magnet_subtitle" varchar;
  ALTER TABLE "settings" ADD COLUMN "lead_magnet_guide_file_id" integer;
  ALTER TABLE "settings" ADD COLUMN "lead_magnet_image_id" integer;
  ALTER TABLE "settings" ADD CONSTRAINT "settings_lead_magnet_guide_file_id_media_id_fk" FOREIGN KEY ("lead_magnet_guide_file_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  ALTER TABLE "settings" ADD CONSTRAINT "settings_lead_magnet_image_id_media_id_fk" FOREIGN KEY ("lead_magnet_image_id") REFERENCES "public"."media"("id") ON DELETE set null ON UPDATE no action;
  CREATE INDEX "settings_lead_magnet_lead_magnet_guide_file_idx" ON "settings" USING btree ("lead_magnet_guide_file_id");`)
}
