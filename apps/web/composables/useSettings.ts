import type { SettingsGlobal } from '@shared/types/payload'

/**
 * Глобальные настройки сайта (контакты, бренд, SEO defaults).
 * Запрашиваются один раз и переиспользуются (useAsyncData с ключом).
 *
 * Payload globals возвращает { value: GlobalData }, оборачиваем в ref.
 */
export function useSettings() {
  const config = useRuntimeConfig()
  const base = config.public.payloadApiUrl as string

  return useAsyncData<{ value?: SettingsGlobal }>(
    'payload-settings',
    () => $fetch<{ value?: SettingsGlobal }>(`${base}/api/globals/settings`),
    { server: true, lazy: false },
  )
}
