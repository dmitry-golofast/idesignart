/**
 * jsonLd — сериализация объекта в текст JSON-LD для useHead.
 *
 * «<» заменяется на \u003c (эквивалентная JSON-запись): `</script>` из контента
 * CMS не закроет тег досрочно и не внедрит разметку. Автоимпортируется Nuxt'ом
 * (utils/) и доступен в <script setup> без импорта.
 */
export function jsonLd(data: unknown): string {
  return JSON.stringify(data).replace(/</g, '\\u003c')
}
