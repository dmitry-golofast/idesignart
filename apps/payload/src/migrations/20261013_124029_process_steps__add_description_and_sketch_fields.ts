import { MigrateUpArgs, MigrateDownArgs, sql } from '@payloadcms/db-postgres'

export async function up({ db, payload, req }: MigrateUpArgs): Promise<void> {
  await db.execute(sql`
   CREATE TYPE "public"."enum_pages_blocks_process_steps_steps_sketch" AS ENUM('plan', 'iso', 'elevation', 'perspective');
  CREATE TYPE "public"."enum__pages_v_blocks_process_steps_steps_sketch" AS ENUM('plan', 'iso', 'elevation', 'perspective');
  ALTER TABLE "pages_blocks_process_steps" ALTER COLUMN "eyebrow" SET DEFAULT 'Процесс';
  ALTER TABLE "pages_blocks_process_steps" ALTER COLUMN "title" SET DEFAULT 'Как мы работаем';
  ALTER TABLE "_pages_v_blocks_process_steps" ALTER COLUMN "eyebrow" SET DEFAULT 'Процесс';
  ALTER TABLE "_pages_v_blocks_process_steps" ALTER COLUMN "title" SET DEFAULT 'Как мы работаем';
  ALTER TABLE "pages_blocks_process_steps_steps" ADD COLUMN "sketch" "enum_pages_blocks_process_steps_steps_sketch" DEFAULT 'plan';
  ALTER TABLE "pages_blocks_process_steps" ADD COLUMN "description" varchar DEFAULT 'Четыре листа — от первой идеи до готового интерьера';
  ALTER TABLE "_pages_v_blocks_process_steps_steps" ADD COLUMN "sketch" "enum__pages_v_blocks_process_steps_steps_sketch" DEFAULT 'plan';
  ALTER TABLE "_pages_v_blocks_process_steps" ADD COLUMN "description" varchar DEFAULT 'Четыре листа — от первой идеи до готового интерьера';`)
}

export async function down({ db, payload, req }: MigrateDownArgs): Promise<void> {
  await db.execute(sql`
   ALTER TABLE "pages_blocks_process_steps" ALTER COLUMN "eyebrow" SET DEFAULT 'Как мы работаем';
  ALTER TABLE "pages_blocks_process_steps" ALTER COLUMN "title" DROP DEFAULT;
  ALTER TABLE "_pages_v_blocks_process_steps" ALTER COLUMN "eyebrow" SET DEFAULT 'Как мы работаем';
  ALTER TABLE "_pages_v_blocks_process_steps" ALTER COLUMN "title" DROP DEFAULT;
  ALTER TABLE "pages_blocks_process_steps_steps" DROP COLUMN "sketch";
  ALTER TABLE "pages_blocks_process_steps" DROP COLUMN "description";
  ALTER TABLE "_pages_v_blocks_process_steps_steps" DROP COLUMN "sketch";
  ALTER TABLE "_pages_v_blocks_process_steps" DROP COLUMN "description";
  DROP TYPE "public"."enum_pages_blocks_process_steps_steps_sketch";
  DROP TYPE "public"."enum__pages_v_blocks_process_steps_steps_sketch";`)
}
