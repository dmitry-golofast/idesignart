/**
 * Одноразовый скрипт: инициализация Payload в dev-режиме, чтобы drizzle
 * запушил схему в БД (новая коллекция tags, posts.categories, теги → tags).
 *
 * При data-loss предупреждениях drizzle спрашивает подтверждение (y/N) —
 * запускать с stdin, в который подано «y»:
 *   (echo y; sleep 120) | node ../../node_modules/.pnpm/tsx@4.22.4/node_modules/tsx/dist/cli.mjs src/scripts/dev-push-schema.ts
 */
import { getPayload } from 'payload'
import payloadConfig from '../payload.config'

async function main() {
  // NODE_ENV в типах Node объявлён readonly — выставляем через Object.assign
  Object.assign(process.env, { NODE_ENV: process.env.NODE_ENV || 'development' })
  const payload = await getPayload({ config: payloadConfig })
  payload.logger.info('[dev-push-schema] схема применена')
  process.exit(0)
}

main().catch((err) => {
  console.error('[dev-push-schema] FAIL:', err?.message ?? err)
  process.exit(1)
})
