import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
   ALTER TYPE "public"."enum_pages_blocks_portfolio_grid_facts_icon" ADD VALUE 'leaf' BEFORE 'compass';
  ALTER TYPE "public"."enum__pages_v_blocks_portfolio_grid_facts_icon" ADD VALUE 'leaf' BEFORE 'compass';
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
  CREATE INDEX "_pages_v_rels_projects_id_idx" ON "_pages_v_rels" USING btree ("projects_id");`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
   DROP TABLE "pages_rels" CASCADE;
  DROP TABLE "_pages_v_rels" CASCADE;
  ALTER TABLE "pages_blocks_portfolio_grid_facts" ALTER COLUMN "icon" SET DATA TYPE text;
  ALTER TABLE "pages_blocks_portfolio_grid_facts" ALTER COLUMN "icon" SET DEFAULT 'layers'::text;
  DROP TYPE "public"."enum_pages_blocks_portfolio_grid_facts_icon";
  CREATE TYPE "public"."enum_pages_blocks_portfolio_grid_facts_icon" AS ENUM('layers', 'house', 'compass');
  ALTER TABLE "pages_blocks_portfolio_grid_facts" ALTER COLUMN "icon" SET DEFAULT 'layers'::"public"."enum_pages_blocks_portfolio_grid_facts_icon";
  ALTER TABLE "pages_blocks_portfolio_grid_facts" ALTER COLUMN "icon" SET DATA TYPE "public"."enum_pages_blocks_portfolio_grid_facts_icon" USING "icon"::"public"."enum_pages_blocks_portfolio_grid_facts_icon";
  ALTER TABLE "_pages_v_blocks_portfolio_grid_facts" ALTER COLUMN "icon" SET DATA TYPE text;
  ALTER TABLE "_pages_v_blocks_portfolio_grid_facts" ALTER COLUMN "icon" SET DEFAULT 'layers'::text;
  DROP TYPE "public"."enum__pages_v_blocks_portfolio_grid_facts_icon";
  CREATE TYPE "public"."enum__pages_v_blocks_portfolio_grid_facts_icon" AS ENUM('layers', 'house', 'compass');
  ALTER TABLE "_pages_v_blocks_portfolio_grid_facts" ALTER COLUMN "icon" SET DEFAULT 'layers'::"public"."enum__pages_v_blocks_portfolio_grid_facts_icon";
  ALTER TABLE "_pages_v_blocks_portfolio_grid_facts" ALTER COLUMN "icon" SET DATA TYPE "public"."enum__pages_v_blocks_portfolio_grid_facts_icon" USING "icon"::"public"."enum__pages_v_blocks_portfolio_grid_facts_icon";
  ALTER TABLE "categories" DROP COLUMN "order";`)
}
