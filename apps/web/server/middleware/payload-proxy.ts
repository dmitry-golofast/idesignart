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

const PAYLOAD_PREFIXES = ['/api', '/admin', '/graphql', '/_next', '/media']

// Роуты Nitro, которые должны остаться на Nuxt-сервере
const LOCAL_PREFIXES = ['/api/__sitemap__', '/api/_nuxt_icon']

function hasPrefix(path: string, prefixes: string[]) {
  return prefixes.some((p) => path === p || path.startsWith(`${p}/`))
}

export default defineEventHandler((event) => {
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
  return proxyRequest(event, `${target}${event.path}`, {
    headers: {
      'x-forwarded-host': getRequestURL(event).host,
    },
  })
})
