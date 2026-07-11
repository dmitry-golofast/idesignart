<script setup lang="ts">
import { computed, ref } from 'vue'

/**
 * PricingCalculator — интерактивный расчёт стоимости.
 * Конверсионный элемент: даёт квалифицированный лид и оправданные ожидания.
 * Результат = ориентир; точный расчёт → отправка формы (лид в Payload).
 */
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
const { form, submit, pending, success } = useLeadForm()
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
  <section class="section bg-[var(--color-surface-alt)]">
    <div class="container-app">
      <div class="mx-auto max-w-3xl text-center">
        <p class="eyebrow">Прозрачные цены</p>
        <h2 class="mt-3 font-display text-[var(--text-h2)]">
          Узнайте стоимость вашего проекта
        </h2>
        <p class="mt-4 text-[var(--color-ink-muted)]">
          Предварительный расчёт за 30 секунд. Точную смету подготовим после брифинга.
        </p>
      </div>

      <div class="mx-auto mt-12 max-w-4xl rounded-[var(--radius-xl)] bg-[var(--color-surface)] p-8 shadow-[var(--shadow-card)] lg:p-12">
        <div class="grid gap-10 lg:grid-cols-[1fr_auto]">
          <!-- Контролы -->
          <div class="space-y-8">
            <!-- Тип объекта -->
            <div>
              <label class="mb-3 block text-sm font-medium text-[var(--color-ink)]">
                Тип объекта
              </label>
              <div class="grid grid-cols-2 gap-2 sm:grid-cols-4">
                <button
                  v-for="pt in propertyTypes"
                  :key="pt.value"
                  type="button"
                  class="rounded-[var(--radius-md)] border-2 px-3 py-2.5 text-sm transition-all duration-[var(--duration-fast)]"
                  :class="propertyType === pt.value
                    ? 'border-[var(--color-accent)] bg-[var(--color-accent-soft)] text-[var(--color-accent-deep)]'
                    : 'border-[var(--color-line)] text-[var(--color-ink-muted)] hover:border-[var(--color-ink-muted)]'"
                  @click="propertyType = pt.value"
                >
                  {{ pt.label }}
                </button>
              </div>
            </div>

            <!-- Площадь -->
            <div>
              <div class="mb-3 flex items-center justify-between">
                <label class="text-sm font-medium text-[var(--color-ink)]">
                  Площадь
                </label>
                <span class="font-display text-xl text-[var(--color-accent)]">
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
              <div class="mt-1 flex justify-between text-xs text-[var(--color-ink-subtle)]">
                <span>20 м²</span>
                <span>500 м²</span>
              </div>
            </div>

            <!-- Уровень услуги -->
            <div>
              <label class="mb-3 block text-sm font-medium text-[var(--color-ink)]">
                Уровень услуги
              </label>
              <div class="space-y-2">
                <button
                  v-for="sl in serviceLevels"
                  :key="sl.value"
                  type="button"
                  class="flex w-full items-center justify-between rounded-[var(--radius-md)] border-2 px-4 py-3 text-left transition-all duration-[var(--duration-fast)]"
                  :class="serviceLevel === sl.value
                    ? 'border-[var(--color-accent)] bg-[var(--color-accent-soft)]'
                    : 'border-[var(--color-line)] hover:border-[var(--color-ink-muted)]'"
                  @click="serviceLevel = sl.value"
                >
                  <span>
                    <span class="block text-sm font-medium text-[var(--color-ink)]">{{ sl.label }}</span>
                    <span class="block text-xs text-[var(--color-ink-muted)]">{{ sl.desc }}</span>
                  </span>
                </button>
              </div>
            </div>
          </div>

          <!-- Результат -->
          <div class="flex flex-col justify-between rounded-[var(--radius-lg)] bg-[var(--color-ink)] p-8 text-[var(--color-canvas)] lg:min-w-[280px]">
            <div>
              <p class="text-xs uppercase tracking-[var(--tracking-caps)] text-[var(--color-canvas)]/50">
                Ориентировочно
              </p>
              <p class="mt-2 font-display text-4xl text-[var(--color-canvas)]">
                {{ formattedPrice }}
              </p>
              <p class="mt-2 text-sm text-[var(--color-canvas)]/60">
                от, за весь проект
              </p>
            </div>
            <UButton
              size="lg"
              color="primary"
              class="mt-8 w-full justify-center"
              :loading="pending"
              @click="requestDetailedQuote"
            >
              Получить точный расчёт
            </UButton>
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
          <div class="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-[var(--color-success)]/10 text-[var(--color-success)]">
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
