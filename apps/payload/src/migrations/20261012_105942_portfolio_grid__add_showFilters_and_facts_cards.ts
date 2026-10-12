import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
   ALTER TABLE "pages_blocks_portfolio_grid" ADD COLUMN "show_filters" boolean DEFAULT true;
  ALTER TABLE "_pages_v_blocks_portfolio_grid" ADD COLUMN "show_filters" boolean DEFAULT true;`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
   ALTER TABLE "pages_blocks_portfolio_grid" DROP COLUMN "show_filters";
  ALTER TABLE "_pages_v_blocks_portfolio_grid" DROP COLUMN "show_filters";`)
}
