<script setup lang="ts">
import { computed, ref } from 'vue'

/**
 * PricingCalculator — интерактивный расчёт стоимости (редизайн v3).
 * Editorial-шапка «05», чипы-фильтры, результат — эспрессо-панель
 * с крупной крем-цифрой и светлой пилюлей. Результат = ориентир;
 * точный расчёт → отправка формы (лид в Payload).
 */
const props = defineProps<{
  /** Номер главы — присваивается по порядку блоков на странице (PageSections) */
  num?: number
}>()

const secNum = computed(() => String(props.num ?? 1).padStart(2, '0'))

const propertyTypes = [
  { label: 'Квартира', value: 'apartment', basePrice: 3000 },
  { label: 'Дом / коттедж', value: 'house', basePrice: 3500 },
  { label: 'Офис', value: 'office', basePrice: 2500 },
  { label: 'Ресторан / кафе', value: 'hospitality', basePrice: 4000 },
]

const serviceLevels = [
  { label: 'Концепт', value: 'concept', multiplier: 0.7, desc: 'Планировка + визуализация' },
  { label: 'Стандарт', value: 'standard', multiplier: 1, desc: 'Полный дизайн-проект' },
  { label: 'Премиум', value: 'premium', multiplier: 1.5, desc: 'Авторский дизайн + надзор' },
]

const area = ref(50)
const propertyType = ref('apartment')
const serviceLevel = ref('standard')

const selectedProperty = computed(() =>
  propertyTypes.find((p) => p.value === propertyType.value)!,
)
const selectedLevel = computed(() =>
  serviceLevels.find((s) => s.value === serviceLevel.value)!,
)

const estimatedPrice = computed(() => {
  const pricePerM2 = selectedProperty.value.basePrice * selectedLevel.value.multiplier
  return Math.round(area.value * pricePerM2)
})

// Форматирование в ₽
const formattedPrice = computed(() =>
  new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: 'RUB',
    maximumFractionDigits: 0,
  }).format(estimatedPrice.value),
)

// Интеграция с лид-формой
const { form, submit, pending } = useLeadForm()
form.source = 'calculator'

const showModal = ref(false)

async function requestDetailedQuote() {
  form.propertyType = selectedProperty.value.label
  form.area = area.value
  form.message = `Прошу точный расчёт: ${selectedProperty.value.label}, ${area.value} м², уровень «${selectedLevel.value.label}». Ориентировочный расчёт на сайте: ${formattedPrice.value}.`
  const ok = await submit()
  if (ok) showModal.value = true
}
</script>

<template>
  <section class="section section-full bg-[var(--color-surface-alt)]">
    <div class="container-app">
      <!-- Editorial-шапка -->
      <div class="sec-head" data-reveal>
        <span class="sec-num" aria-hidden="true">{{ secNum }}</span>
        <h2 class="sec-title">Узнайте стоимость</h2>
      </div>
      <p class="mt-6 max-w-md text-[15px] leading-relaxed text-[var(--color-ink-muted)]" data-reveal="fade" style="--reveal-delay: 120ms">
        Предварительный расчёт за 30 секунд. Точную смету подготовим после брифинга.
      </p>

      <div
        class="mt-10 rounded-[var(--radius-xl)] border border-[var(--color-line)] bg-[var(--color-surface)] p-7 sm:p-10 lg:p-12"
        data-reveal
      >
        <div class="grid gap-12 lg:grid-cols-[1fr_auto]">
          <!-- Контролы -->
          <div class="space-y-10">
            <!-- Тип объекта -->
            <div>
              <p class="mb-4 text-[11px] font-medium tracking-[0.16em] text-[var(--color-ink-muted)] uppercase">
                Тип объекта
              </p>
              <div class="flex flex-wrap gap-2">
                <button
                  v-for="pt in propertyTypes"
                  :key="pt.value"
                  type="button"
                  :aria-pressed="propertyType === pt.value"
                  class="chip-filter"
                  @click="propertyType = pt.value"
                >
                  {{ pt.label }}
                </button>
              </div>
            </div>

            <!-- Площадь -->
            <div>
              <div class="mb-4 flex items-end justify-between">
                <p class="text-[11px] font-medium tracking-[0.16em] text-[var(--color-ink-muted)] uppercase">
                  Площадь
                </p>
                <span class="font-display text-2xl font-extrabold tracking-[-0.02em] text-[var(--color-ink)]">
                  {{ area }} м²
                </span>
              </div>
              <USlider
                v-model="area"
                :min="20"
                :max="500"
                :step="5"
                size="lg"
              />
              <div class="mt-2 flex justify-between text-xs text-[var(--color-ink-subtle)]">
                <span>20 м²</span>
                <span>500 м²</span>
              </div>
            </div>

            <!-- Уровень услуги -->
            <div>
              <p class="mb-4 text-[11px] font-medium tracking-[0.16em] text-[var(--color-ink-muted)] uppercase">
                Уровень услуги
              </p>
              <div class="space-y-2.5">
                <button
                  v-for="sl in serviceLevels"
                  :key="sl.value"
                  type="button"
                  :aria-pressed="serviceLevel === sl.value"
                  class="flex w-full items-center justify-between rounded-[var(--radius-md)] border px-5 py-4 text-left transition-colors duration-200"
                  :class="serviceLevel === sl.value
                    ? 'border-[var(--color-ink)] bg-[var(--color-surface)]'
                    : 'border-[var(--color-line)] bg-transparent hover:border-[var(--color-ink-muted)]'"
                  @click="serviceLevel = sl.value"
                >
                  <span>
                    <span class="block text-[15px] font-bold text-[var(--color-ink)]">{{ sl.label }}</span>
                    <span class="block text-xs text-[var(--color-ink-muted)]">{{ sl.desc }}</span>
                  </span>
                  <span
                    class="h-4 w-4 shrink-0 rounded-full border-2 transition-colors duration-200"
                    :class="serviceLevel === sl.value ? 'border-[var(--color-ink)] bg-[var(--color-gold)]' : 'border-[var(--color-line)]'"
                    aria-hidden="true"
                  />
                </button>
              </div>
            </div>
          </div>

          <!-- Результат: эспрессо-панель -->
          <div class="flex flex-col justify-between rounded-[var(--radius-lg)] bg-[var(--color-espresso)] p-8 text-[#f6f1e7] lg:min-w-[300px]">
            <div>
              <p class="text-[11px] font-medium tracking-[0.16em] text-[#f6f1e7]/55 uppercase">
                Ориентировочно
              </p>
              <p class="mt-4 font-display text-[clamp(2rem,3vw,2.75rem)] leading-none font-extrabold tracking-[-0.02em] text-[#f6f1e7]">
                {{ formattedPrice }}
              </p>
              <p class="mt-3 text-sm text-[#f6f1e7]/55">
                от, за весь проект
              </p>
            </div>
            <button
              type="button"
              class="btn-pill btn-pill-light mt-10 w-full justify-between"
              :disabled="pending"
              @click="requestDetailedQuote"
            >
              <span>{{ pending ? 'Отправляем...' : 'Точный расчёт' }}</span>
              <span class="btn-pill-orb" aria-hidden="true">
                <UIcon v-if="pending" name="i-lucide-loader-circle" class="h-3.5 w-3.5 animate-spin" />
                <svg v-else viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" class="h-3.5 w-3.5">
                  <path d="M7 17 17 7" />
                  <path d="M8 7h9v9" />
                </svg>
              </span>
            </button>
          </div>
        </div>
      </div>

      <p class="mt-6 text-center text-xs text-[var(--color-ink-subtle)]">
        Расчёт предварительный и не является публичной офертой.
      </p>
    </div>

    <!-- Модалка успеха -->
    <UModal v-model:open="showModal">
      <template #content>
        <div class="p-8 text-center">
          <div class="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-success/10 text-success">
            <UIcon name="i-lucide-check" class="h-8 w-8" />
          </div>
          <h3 class="font-display text-2xl text-[var(--color-ink)]">Заявка отправлена!</h3>
          <p class="mt-2 text-[var(--color-ink-muted)]">
            Свяжемся с вами в течение рабочего дня и подготовим точный расчёт.
          </p>
          <UButton color="neutral" variant="outline" class="mt-6" @click="showModal = false">
            Закрыть
          </UButton>
        </div>
      </template>
    </UModal>
  </section>
</template>
