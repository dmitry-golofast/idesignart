/**
 * useAuth — авторизован ли посетитель на сайте.
 *
 * Личный кабинет — админка Payload (/admin, коллекция users): сайт и
 * админка same-origin (в dev — прокси Nuxt, в проде — Caddy), поэтому
 * после входа браузер хранит cookie сессии Payload «payload-token»
 * (httpOnly, path=/). На SSR Nuxt читает её из заголовков запроса и
 * передаёт значение на клиент через Nuxt-payload — напрямую из JS
 * браузера она недоступна. Достаточно факта наличия cookie: протухший
 * токен не страшен, /admin сам перенаправит на страницу входа.
 */
export function useAuth() {
  const token = useCookie('payload-token')

  const isAuthenticated = computed(() => Boolean(token.value))

  return { isAuthenticated }
}
