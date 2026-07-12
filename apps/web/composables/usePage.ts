import type { PagesResponse } from '@shared/types/payload'

/**
 * usePage — получает страницу из Payload по slug с блоками sections.
 * Главная страница имеет slug 'home'.
 *
 * Использует useAsyncData с уникальным ключом.
 * getData() — чистая функция для повторных запросов при навигации.
 */
export function usePage(slug: string) {
  const config = useRuntimeConfig()
  const base = config.public.payloadApiUrl as string
  const normalized = slug.replace(/^\/+|\/+$/g, '')

  const getData = () => $fetch<PagesResponse>(`${base}/api/pages`, {
    query: {
      depth: 3,
      limit: 1,
      where: JSON.stringify({
        slug: { equals: normalized },
        _status: { equals: 'published' },
      }),
    },
  })

  return useAsyncData<PagesResponse>(
    `page-${normalized}`,
    getData,
    {
      server: true,
      lazy: false,
      // Перепроверяем данные при клиентской навигации обратно на страницу
      getCachedData(key) {
        return useNuxtApp().payload.data[key] || useNuxtApp().static.data[key]
      },
    },
  )
}
