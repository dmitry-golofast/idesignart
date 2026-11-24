/**
 * useAuth — авторизован ли посетитель на сайте.
 *
 * Личный кабинет — админка Payload (/admin, коллекция users): сайт и
 * админка same-origin (в dev — прокси Nuxt, в проде — Caddy), поэтому
 * после входа браузер хранит cookie сессии Payload «payload-token»
 * (httpOnly, path=/). Её видит только сервер (в заголовках запроса),
 * напрямую из JS браузера она недоступна. Достаточно факта наличия
 * cookie: протухший токен не страшен, /admin сам перенаправит на
 * страницу входа.
 *
 * Факт авторизации считается на SSR и уходит клиенту через payload
 * (useState) — первый рендер клиента совпадает с серверским. useCookie
 * для этого не годится: на клиенте он читает document.cookie, где
 * httpOnly-cookie нет, и при гидратации шапка перекидывалась с
 * «В личный кабинет» обратно на гостевую кнопку (Hydration mismatch).
 * Значение живёт до перезагрузки страницы: вход и выход происходят
 * в /admin и сопровождаются полной загрузкой.
 */
export function useAuth() {
  const token = useCookie('payload-token')

  const isAuthenticated = useState<boolean>('auth:is-authenticated', () => Boolean(token.value))

  return { isAuthenticated: readonly(isAuthenticated) }
}
