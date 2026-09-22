import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
   CREATE TYPE "public"."enum_header_cta_icon" AS ENUM('arrow-up-right', 'arrow-right', 'none');
  CREATE TYPE "public"."enum_header_cta_variant" AS ENUM('accent', 'dark', 'outline');
  CREATE TYPE "public"."enum_header_appearance_font_family" AS ENUM('inter', 'manrope', 'system');
  CREATE TABLE "header_navigation" (
  	"_order" integer NOT NULL,
  	"_parent_id" integer NOT NULL,
  	"id" varchar PRIMARY KEY NOT NULL,
  	"label" varchar NOT NULL,
  	"href" varchar NOT NULL,
  	"new_tab" boolean DEFAULT false
  );
  
  CREATE TABLE "header" (
  	"id" serial PRIMARY KEY NOT NULL,
  	"phone" varchar,
  	"cta_enabled" boolean DEFAULT true,
  	"cta_label" varchar DEFAULT 'Зарегистрироваться',
  	"cta_href" varchar DEFAULT '/register',
  	"cta_new_tab" boolean DEFAULT false,
  	"cta_icon" "enum_header_cta_icon" DEFAULT 'arrow-up-right',
  	"cta_variant" "enum_header_cta_variant" DEFAULT 'accent',
  	"appearance_background_color" varchar DEFAULT '#F8F7F3',
  	"appearance_text_color" varchar DEFAULT '#080808',
  	"appearance_muted_text_color" varchar DEFAULT '#303030',
  	"appearance_accent_color" varchar DEFAULT '#D7EF28',
  	"appearance_accent_text_color" varchar DEFAULT '#080808',
  	"appearance_font_family" "enum_header_appearance_font_family" DEFAULT 'inter',
  	"appearance_brand_px" numeric DEFAULT 30 NOT NULL,
  	"appearance_navigation_px" numeric DEFAULT 16 NOT NULL,
  	"appearance_button_text_px" numeric DEFAULT 18 NOT NULL,
  	"appearance_button_height_px" numeric DEFAULT 56 NOT NULL,
  	"appearance_button_padding_x_px" numeric DEFAULT 28 NOT NULL,
  	"appearance_button_radius_px" numeric DEFAULT 0 NOT NULL,
  	"appearance_header_height_px" numeric DEFAULT 88 NOT NULL,
  	"updated_at" timestamp(3) with time zone,
  	"created_at" timestamp(3) with time zone
  );
  
  ALTER TABLE "header_navigation" ADD CONSTRAINT "header_navigation_parent_id_fk" FOREIGN KEY ("_parent_id") REFERENCES "public"."header"("id") ON DELETE cascade ON UPDATE no action;
  CREATE INDEX "header_navigation_order_idx" ON "header_navigation" USING btree ("_order");
  CREATE INDEX "header_navigation_parent_id_idx" ON "header_navigation" USING btree ("_parent_id");`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
   DROP TABLE "header_navigation" CASCADE;
  DROP TABLE "header" CASCADE;
  DROP TYPE "public"."enum_header_cta_icon";
  DROP TYPE "public"."enum_header_cta_variant";
  DROP TYPE "public"."enum_header_appearance_font_family";`)
}
