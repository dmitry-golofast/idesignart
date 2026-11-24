/**
 * usePayload — базовый composable для запросов к Payload REST API.
 *
 * Все остальные data-composables строятся поверх него.
 * Запросы идут через useFetch с типизацией из Payload-генерируемых типов.
 *
 * Note: useFetch / useRuntimeConfig / computed — Nuxt auto-imports.
 */

const PAYLOAD_DEFAULTS: Record<string, string> = {
  draft: 'false',
  depth: '2',
}

export function usePayload<T>(
  endpoint: string,
  query: Record<string, string> | Ref<Record<string, string>> | (() => Record<string, string>) = {},
  /**
   * Доп. опции useFetch (например, getCachedData). Полезно точечно
   * отключать межнавигационный кеш для «живых» данных (списки из CMS).
   */
  fetchOptions: Record<string, unknown> = {},
) {
  const config = useRuntimeConfig()
  const base = config.public.payloadApiUrl as string

  // query может быть реактивным (computed/getter) — URL пересчитывается,
  // а useFetch при смене URL перезапрашивает данные без перезагрузки страницы
  const queryString = computed(() => {
    const params = new URLSearchParams({
      ...PAYLOAD_DEFAULTS,
      ...toValue(query),
    })
    return params.toString()
  })

  const url = computed(() => `${base}/api/${endpoint}?${queryString.value}`)

  return useFetch<T>(url, {
    // Ключ реактивный: входит в него и сам query, поэтому смена query
    // (например, тега фильтра) меняет ключ — useAsyncData перезапрашивает
    // данные. Со статическим ключом URL менялся «вхолостую»: перезапроса
    // не происходило, список не обновлялся при смене фильтра.
    key: computed(() => `payload-${endpoint}-${JSON.stringify(toValue(query))}`),
    server: true,
    lazy: false,
    ...fetchOptions,
  })
}

/**
 * getCachedData для «живых» списков CMS: при гидратации берём данные
 * из SSR-payload (без повторного запроса), а при последующих клиентских
 * заходах на страницу кеш игнорируем — состав/теги постов всегда свежие.
 */
export function freshOnVisit(key: string, nuxtApp: { isHydrating: boolean; payload: { data: Record<string, unknown> } }) {
  return nuxtApp.isHydrating ? nuxtApp.payload.data[key] : undefined
}

/**
 * Хелпер для построения Payload `where`-фильтров (JSON в query string).
 */
export function payloadWhere(filter: Record<string, any>) {
  return JSON.stringify(filter)
}
