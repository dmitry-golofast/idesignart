import { reactive, ref } from 'vue'
import { z } from 'zod'

/**
 * useLeadForm — отправка заявки в Payload (коллекция `leads`).
 *
 * Валидация через zod, состояние pending/success/error.
 * Используется в ContactForm, PricingCalculator, LeadMagnet.
 */

const leadSchema = z.object({
  name: z.string().min(2, 'Имя должно быть не короче 2 символов'),
  email: z.string().email('Некорректный email').optional().or(z.literal('')),
  phone: z.string().min(6, 'Некорректный телефон').optional().or(z.literal('')),
  service: z.string().optional(),
  message: z.string().min(10, 'Расскажите подробнее (минимум 10 символов)'),
  propertyType: z.string().optional(),
  area: z.number().optional(),
  budget: z.string().optional(),
  timeline: z.string().optional(),
  source: z.string().default('website'),
  consent: z.literal(true, { errorMap: () => ({ message: 'Требуется согласие на обработку данных' }) }),
}).refine(
  (data) => data.email || data.phone,
  { message: 'Укажите email или телефон для связи', path: ['contact'] },
)

export type LeadFormData = z.input<typeof leadSchema>

export function useLeadForm() {
  const config = useRuntimeConfig()
  const base = config.public.payloadApiUrl as string

  const pending = ref(false)
  const success = ref(false)
  const error = ref<string | null>(null)
  const errors = ref<Record<string, string>>({})

  const form = reactive<LeadFormData>({
    name: '',
    email: '',
    phone: '',
    service: '',
    message: '',
    propertyType: '',
    area: undefined,
    budget: '',
    timeline: '',
    source: 'website',
    consent: false as unknown as true,
  })

  function reset() {
    Object.assign(form, {
      name: '', email: '', phone: '', service: '', message: '',
      propertyType: '', area: undefined, budget: '', timeline: '',
      source: 'website', consent: false,
    })
    success.value = false
    error.value = null
    errors.value = {}
  }

  async function submit() {
    pending.value = true
    error.value = null
    errors.value = {}

    const parsed = leadSchema.safeParse(form)
    if (!parsed.success) {
      parsed.error.issues.forEach((issue) => {
        const key = issue.path[0]?.toString() ?? '_'
        errors.value[key] = issue.message
      })
      pending.value = false
      return false
    }

    try {
      const res = await $fetch(`${base}/api/leads`, {
        method: 'POST',
        body: {
          name: parsed.data.name,
          contact: {
            email: parsed.data.email || undefined,
            phone: parsed.data.phone || undefined,
          },
          service: parsed.data.service || undefined,
          projectDetails: {
            propertyType: parsed.data.propertyType || undefined,
            area: parsed.data.area || undefined,
            budget: parsed.data.budget || undefined,
            timeline: parsed.data.timeline || undefined,
          },
          message: parsed.data.message,
          source: parsed.data.source,
          consent: parsed.data.consent,
        },
      })
      success.value = true
      return true
    } catch (e: any) {
      error.value = e?.data?.message || 'Не удалось отправить заявку. Попробуйте позже.'
      return false
    } finally {
      pending.value = false
    }
  }

  return { form, pending, success, error, errors, submit, reset }
}
