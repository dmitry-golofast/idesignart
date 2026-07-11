import type { PagesResponse } from '@shared/types/payload'

/**
 * usePage — получает страницу из Payload по slug с блоками sections.
 * Главная страница имеет slug 'home'.
 *
 * Использует useAsyncData напрямую (надёжнее, чем usePayload с URLSearchParams).
 */
export function usePage(slug: string) {
  const config = useRuntimeConfig()
  const base = config.public.payloadApiUrl as string

  // Нормализуем slug: убираем ведущие/завершающие слеши
  const normalized = slug.replace(/^\/+|\/+$/g, '')

  return useAsyncData<PagesResponse>(
    `page-${normalized}`,
    () => $fetch<PagesResponse>(`${base}/api/pages`, {
      query: {
        depth: 3,
        limit: 1,
        where: JSON.stringify({
          slug: { equals: normalized },
          _status: { equals: 'published' },
        }),
      },
    }),
    { server: true, lazy: false },
  )
}
