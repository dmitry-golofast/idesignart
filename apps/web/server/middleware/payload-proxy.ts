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
 * /api/__sitemap__ не проксируется: это серверный роут самого Nuxt
 * (@nuxtjs/sitemap), поэтому проверка идёт до общего префикса /api.
 */

const PAYLOAD_PREFIXES = ['/api', '/admin', '/graphql', '/_next', '/media']

// Роуты Nitro, которые должны остаться на Nuxt-сервере
const LOCAL_PREFIXES = ['/api/__sitemap__']

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

  return proxyRequest(event, `${target}${event.path}`)
})
