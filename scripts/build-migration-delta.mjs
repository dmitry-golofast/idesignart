import fs from 'node:fs'

// Собирает apps/payload/migrations-delta.sql — SQL миграций в порядке следования.
// Каждая — в транзакции, с записью в payload_migrations, как делает payload migrate.
// Нужен для серверов, где payload CLI зависает (tsx spin на node22-alpine).
//
// Использование:
//   node scripts/build-migration-delta.mjs                      — все миграции (пустая БД)
//   node scripts/build-migration-delta.mjs 20261021_130800      — с указанной и до конца
//     (для сервера, где все миграции ДО неё уже применены)
const dir = 'apps/payload/src/migrations'
const startArg = process.argv[2]
const files = fs
  .readdirSync(dir)
  .filter((f) => f.endsWith('.ts') && f !== 'index.ts')
  .sort()
const startIdx = startArg ? files.findIndex((f) => f.startsWith(startArg)) : 0
if (startIdx === -1) {
  console.error(`Миграция «${startArg}» не найдена в ${dir}`)
  process.exit(1)
}
const later = files.slice(startIdx)
if (later.length === 0) {
  console.error('Нет миграций для дельты')
  process.exit(1)
}

let out = [
  `-- Догон схемы БД: миграции ${later[0].replace('.ts', '')} … ${later[later.length - 1].replace('.ts', '')}.`,
  '-- Каждая миграция — в транзакции, как делает payload migrate.',
  '-- Применение: docker exec -i idesignart-db psql -U postgres -d idesignart < apps/payload/migrations-delta.sql',
  '',
]
for (const f of later) {
  const src = fs.readFileSync(`${dir}/${f}`, 'utf8')
  const upIdx = src.indexOf('export async function up')
  const body = src.slice(src.indexOf('`', upIdx) + 1, src.indexOf('`)', upIdx))
  out.push(`-- ===== ${f} =====`)
  out.push('BEGIN;')
  out.push(body.trim())
  out.push(
    `INSERT INTO payload_migrations (name, batch, updated_at, created_at) VALUES ('${f.replace('.ts', '')}', 1, now(), now());`,
  )
  out.push('COMMIT;')
  out.push('')
}
fs.writeFileSync('apps/payload/migrations-delta.sql', out.join('\n'))
console.log('migrations-delta.sql written, migrations:', later.length, `(${later[0]} … ${later[later.length - 1]})`)
