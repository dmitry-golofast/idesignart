import type { Header } from '../shared/types/payload'

/**
 * useHeader — global «Шапка сайта»: пункты меню, телефон, кнопка действия.
 * REST отдаёт объект глобала напрямую. Fetch дедуплицируется по ключу.
 */
export function useHeader() {
  const config = useRuntimeConfig()
  const base = config.public.payloadApiUrl as string

  return useAsyncData<Header | undefined>(
    'payload-header',
    () => $fetch<Header>(`${base}/api/globals/header`, {
      query: { depth: '0' },
    }),
    { server: true, lazy: false },
  )
}
