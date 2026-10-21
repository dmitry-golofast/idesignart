import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

/* Ручная миграция (migrate:create зависает на интерактивном вопросе drizzle
   про переименования энумов — см. 20261021_130800_seo_plugin_meta_group):
   поле phone выведено из global «header» — телефон шапки берётся из
   контактов Settings, затем из переменных окружения. */
export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
  ALTER TABLE "header" DROP COLUMN "phone";`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
  ALTER TABLE "header" ADD COLUMN "phone" varchar;`)
}
