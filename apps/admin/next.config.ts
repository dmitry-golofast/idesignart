import { withPayload } from '@payloadcms/next/withPayload'

/**
 * Next.js конфиг для Payload admin.
 *
 * config резолвится через tsconfig paths: @payload-config → ../payload/src/payload.config.ts
 * withPayload добавляет нужные webpack/transpile настройки для Payload.
 */
export default withPayload({
  // Здесь можно добавить стандартные next.js опции
}, {
  // devBundleServerComponents: true (по умолчанию)
})
