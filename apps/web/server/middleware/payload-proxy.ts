/**
 * Same-origin прокси к Payload CMS (apps/admin, Next.js).
 *
 * Сайт и CMS работают на одном хосте и порту: браузер ходит только на
 * origin Nuxt-сервера, а пути Payload (/admin, /api, /graphql, /_next,
 * /media) проксируются на admin-сервер. Так dev-окружение повторяет
 * продовую схему (в проде эти пути роутит Caddy — запросы до web не
 * доходят, и мидлварь остаётся в качестве страховки).
 *
 * Цель прокси — PAYLOAD_PROXY_TARGET (по умолчанию http://localhost:3001).
 * Пустое значение отключает прокси.
 *
 * /api/__sitemap__ и /api/_nuxt_icon не проксируются: это серверные роуты
 * самого Nuxt (@nuxtjs/sitemap и @nuxt/icon), поэтому проверка идёт до
 * общего префикса /api.
 */

const PAYLOAD_PREFIXES = [
  '/api',
  '/admin',
  '/graphql',
  '/_next',
  '/media',
  // Dev-роуты оверлея ошибок Next.js (символизация стектрейсов в админке)
  '/__nextjs',
]

// Роуты Nitro, которые должны остаться на Nuxt-сервере
const LOCAL_PREFIXES = ['/api/__sitemap__', '/api/_nuxt_icon']

function hasPrefix(path: string, prefixes: string[]) {
  return prefixes.some((p) => path === p || path.startsWith(`${p}/`))
}

// Обрыв соединения клиентом или upstream (закрытие вкладки, отмена навигации,
// HMR/SSE-стримы админки). Отвечать уже нечем — ошибку нужно поглотить.
function isConnectionAbort(err: unknown) {
  const code = (err as { code?: string } | null)?.code
  return (
    code === 'ECONNRESET' ||
    code === 'ECONNABORTED' ||
    code === 'EPIPE' ||
    code === 'ERR_STREAM_PREMATURE_CLOSE'
  )
}

export default defineEventHandler(async (event) => {
  const target = useRuntimeConfig(event).payloadProxyTarget as string
  if (!target) return

  // pathname без query: event.path включает строку запроса
  const { pathname } = getRequestURL(event)
  if (!hasPrefix(pathname, PAYLOAD_PREFIXES)) return
  if (hasPrefix(pathname, LOCAL_PREFIXES)) return

  // Next.js в админке проверяет Server Actions (загрузка файлов в блоках):
  // x-forwarded-host обязан совпадать с origin браузера, иначе save падает
  // 500 «Invalid Server Actions request». Host при проксировании становится
  // localhost:3001, поэтому явно возвращаем хост исходного запроса.
  try {
    return await proxyRequest(event, `${target}${event.path}`, {
      headers: {
        'x-forwarded-host': getRequestURL(event).host,
      },
    })
  } catch (err) {
    // Проглоченный reject обязателен: иначе он доходит до nuxi как
    // unhandledRejection, и dev-сервер целиком перезапускается
    // («Restarting Nuxt due to error»), а на Windows иногда падает нативно
    // (exit 0xC0000005), роняя весь pnpm dev.
    if (event.node.res.headersSent || isConnectionAbort(err)) return
    throw err
  }
})
