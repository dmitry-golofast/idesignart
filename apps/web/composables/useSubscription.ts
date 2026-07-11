import { reactive, ref } from 'vue'
import { z } from 'zod'

/**
 * useSubscription — подписка на email (лид-магнит / рассылка).
 * Сохраняет контакт в Payload (коллекция subscriptions).
 * После успешной подписки — отдаёт ссылку на скачивание гида.
 */

const subSchema = z.object({
  email: z.string().email('Некорректный email'),
  name: z.string().optional(),
  consent: z.literal(true, {
    errorMap: () => ({ message: 'Требуется согласие на обработку данных' }),
  }),
})

export type SubscriptionFormData = z.input<typeof subSchema>

export function useSubscription(options: {
  source?: string
  leadMagnet?: string
} = {}) {
  const config = useRuntimeConfig()
  const base = config.public.payloadApiUrl as string

  const pending = ref(false)
  const success = ref(false)
  const error = ref<string | null>(null)
  const errors = ref<Record<string, string>>({})

  const form = reactive<SubscriptionFormData>({
    email: '',
    name: '',
    consent: false as unknown as true,
  })

  // Ссылка на гид вернётся после подписки (из Settings.leadMagnet.guideFile)
  const downloadUrl = ref<string | null>(null)

  async function submit() {
    pending.value = true
    error.value = null
    errors.value = {}

    const parsed = subSchema.safeParse(form)
    if (!parsed.success) {
      parsed.error.issues.forEach((issue) => {
        const key = issue.path[0]?.toString() ?? '_'
        errors.value[key] = issue.message
      })
      pending.value = false
      return false
    }

    try {
      const res = await $fetch<{ doc: { id: string } }>(`${base}/api/subscriptions`, {
        method: 'POST',
        body: {
          email: parsed.data.email,
          name: parsed.data.name || undefined,
          source: options.source || 'lead-magnet',
          leadMagnet: options.leadMagnet,
          consent: parsed.data.consent,
          status: 'subscribed',
        },
      })

      // Тянем ссылку на гид из глобальных настроек
      const settings = await $fetch<{ leadMagnet?: { guideFile?: { url?: string } } }>(
        `${base}/api/globals/settings`,
      )
      const guideUrl = settings?.leadMagnet?.guideFile?.url
      if (guideUrl) {
        downloadUrl.value = guideUrl.startsWith('http') ? guideUrl : `${base}${guideUrl}`
      }

      success.value = true
      return true
    } catch (e: any) {
      // Payload возвращает 409 при дубликате email (unique)
      if (e?.statusCode === 409 || e?.response?.status === 409) {
        error.value = 'Вы уже подписаны. Проверьте почту — гид был отправлен ранее.'
      } else {
        error.value = 'Не удалось подписаться. Попробуйте позже.'
      }
      return false
    } finally {
      pending.value = false
    }
  }

  function reset() {
    Object.assign(form, { email: '', name: '', consent: false })
    success.value = false
    error.value = null
    errors.value = {}
    downloadUrl.value = null
  }

  return { form, pending, success, error, errors, downloadUrl, submit, reset }
}
