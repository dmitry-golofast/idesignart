import fs from 'node:fs'

// Собирает delta.sql: SQL миграций с 3-й по последнюю, в порядке следования.
// Каждая — в транзакции, с записью в payload_migrations, как делает payload migrate.
const dir = 'apps/payload/src/migrations'
const files = fs
  .readdirSync(dir)
  .filter((f) => f.endsWith('.ts') && f !== 'index.ts')
  .sort()
const later = files.slice(2) // первые две уже применены на сервере

let out = [
  '-- Догон схемы БД: миграции 3–11 (для сервера, где payload_migrations = первые 2).',
  '-- Каждая миграция — в транзакции, как делает payload migrate. Контент не затрагивается.',
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
console.log('migrations-delta.sql written, migrations:', later.length)
