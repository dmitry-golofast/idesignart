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
  query: Record<string, string> = {},
) {
  const config = useRuntimeConfig()
  const base = config.public.payloadApiUrl as string

  const queryString = computed(() => {
    const params = new URLSearchParams({
      ...PAYLOAD_DEFAULTS,
      ...query,
    })
    return params.toString()
  })

  const url = computed(() => `${base}/api/${endpoint}?${queryString.value}`)

  return useFetch<T>(url, {
    key: `payload-${endpoint}-${JSON.stringify(query)}`,
    server: true,
    lazy: false,
  })
}

/**
 * Хелпер для построения Payload `where`-фильтров (JSON в query string).
 */
export function payloadWhere(filter: Record<string, any>) {
  return JSON.stringify(filter)
}
