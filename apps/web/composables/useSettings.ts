import type { SettingsGlobal } from '../shared/payload-helpers'

/**
 * Глобальные настройки сайта (контакты, бренд, SEO defaults).
 * Запрашиваются один раз и переиспользуются (useAsyncData с ключом).
 *
 * REST /api/globals/settings возвращает объект глобала напрямую
 * (без обёртки { value }), depth=1 — разворачивает upload-поля
 * (логотип, defaultOgImage) в объекты с url.
 */
export function useSettings() {
  const config = useRuntimeConfig()
  const base = config.public.payloadApiUrl as string

  return useAsyncData<SettingsGlobal | undefined>(
    'payload-settings',
    () => $fetch<SettingsGlobal>(`${base}/api/globals/settings`, {
      query: { depth: '1' },
    }),
    { server: true, lazy: false },
  )
}
