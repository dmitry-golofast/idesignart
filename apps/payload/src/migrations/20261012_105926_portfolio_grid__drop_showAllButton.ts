import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
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
  ALTER TABLE "_pages_v_blocks_portfolio_grid" DROP COLUMN "show_all_button";`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
   ALTER TABLE "pages_blocks_portfolio_grid_facts" DISABLE ROW LEVEL SECURITY;
  ALTER TABLE "_pages_v_blocks_portfolio_grid_facts" DISABLE ROW LEVEL SECURITY;
  DROP TABLE "pages_blocks_portfolio_grid_facts" CASCADE;
  DROP TABLE "_pages_v_blocks_portfolio_grid_facts" CASCADE;
  ALTER TABLE "pages_blocks_portfolio_grid" ALTER COLUMN "eyebrow" SET DEFAULT 'Избранные проекты';
  ALTER TABLE "_pages_v_blocks_portfolio_grid" ALTER COLUMN "eyebrow" SET DEFAULT 'Избранные проекты';
  ALTER TABLE "pages_blocks_portfolio_grid" ADD COLUMN "show_all_button" boolean DEFAULT true;
  ALTER TABLE "_pages_v_blocks_portfolio_grid" ADD COLUMN "show_all_button" boolean DEFAULT true;
  DROP TYPE "public"."enum_pages_blocks_portfolio_grid_facts_icon";
  DROP TYPE "public"."enum__pages_v_blocks_portfolio_grid_facts_icon";`)
}
