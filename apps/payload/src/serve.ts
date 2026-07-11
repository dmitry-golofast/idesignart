/**
 * apps/payload — теперь только schema + config источник.
 *
 * HTTP-сервер (admin UI + REST/GraphQL API) запускается через apps/admin
 * (Next.js + @payloadcms/next). Этот файл оставлен для совместимости
 * с командой `payload run` (например, для скриптов seed/migration).
 *
 * Запуск отдельной команды:
 *   payload run src/serve.ts
 */
import { getPayload } from 'payload'
import payloadConfig from './payload.config'

async function main() {
  const payload = await getPayload({ config: payloadConfig })
  payload.logger.info('Payload Local API готов (для скриптов).')
  // Процесс завершается — это нормально для одноразовых скриптов.
  process.exit(0)
}

main().catch((err) => {
  console.error('Ошибка:', err)
  process.exit(1)
})
