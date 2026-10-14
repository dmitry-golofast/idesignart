<script setup lang="ts">
import { computed } from 'vue'

/**
 * ContactForm — основная форма захвата лидов (редизайн v3, язык ayocin).
 * Поля с hairline-подчёркиванием (как email-строка в футере ayocin),
 * микро-лейблы caps, кнопка — светлая/тёмная пилюля со стрелкой-орбом.
 * Валидация через useLeadForm (zod), отправка в Payload (коллекция leads).
 */

const props = defineProps<{
  title?: string
  eyebrow?: string
  description?: string
  defaultService?: string
  source?: string
  variant?: 'light' | 'dark'
}>()

const { data: servicesData } = useServices()
const serviceOptions = computed<{ label: string; value: string | number }[]>(() =>
  (servicesData.value?.docs || []).map((s) => ({
    label: s.title,
    value: s.id,
  })),
)

const { form, submit, pending, success, error, errors } = useLeadForm()

// Применяем defaults из props
if (props.defaultService) form.service = props.defaultService
if (props.source) form.source = props.source

const isDark = computed(() => props.variant === 'dark')

const trustPoints = [
  { icon: 'i-lucide-clock', text: 'Ответ в течение рабочего дня' },
  { icon: 'i-lucide-shield-check', text: 'Договор и фиксированная смета' },
  { icon: 'i-lucide-map-pin', text: 'Работаем по городу и удалённо' },
]
</script>

<template>
  <section
    class="section section-full"
    :class="isDark ? 'cf cf--dark bg-[var(--color-espresso)]' : 'cf bg-[var(--color-canvas)]'"
  >
    <div class="container-app">
      <div class="grid gap-14 lg:grid-cols-2 lg:gap-24">
        <!-- Левая колонка — текст -->
        <div>
          <p class="eyebrow" data-reveal="fade">{{ eyebrow || 'Связаться' }}</p>
          <h2 class="section-title mt-4" data-reveal>{{ title || 'Расскажите о вашем проекте' }}</h2>
          <p
            class="mt-5 max-w-md text-[17px] leading-relaxed"
            :class="isDark ? 'text-[#f6f1e7]/65' : 'text-[var(--color-ink-muted)]'"
            data-reveal="fade"
            style="--reveal-delay: 120ms"
          >
            {{ description || 'Ответим в течение рабочего дня. Консультация — бесплатно.' }}
          </p>

          <!-- Доп. контакты: иконка-кольцо + текст -->
          <ul v-if="!isDark" class="mt-10 space-y-5">
            <li
              v-for="point in trustPoints"
              :key="point.icon"
              class="flex items-center gap-4 text-sm text-[var(--color-ink-muted)]"
              data-reveal="fade"
            >
              <span class="icon-ring !h-11 !w-11" aria-hidden="true">
                <UIcon :name="point.icon" class="h-4 w-4" />
              </span>
              <span>{{ point.text }}</span>
            </li>
          </ul>
        </div>

        <!-- Правая колонка — форма -->
        <div>
          <!-- Состояние успеха -->
          <div
            v-if="success"
            class="flex flex-col items-start border-t border-[var(--color-line)] pt-8"
          >
            <span class="icon-ring !h-14 !w-14 text-[var(--color-success)]" aria-hidden="true">
              <UIcon name="i-lucide-check" class="h-6 w-6" />
            </span>
            <h3 class="section-title mt-6 !text-3xl">Заявка отправлена!</h3>
            <p class="mt-3 text-[var(--color-ink-muted)]">
              Спасибо! Свяжемся с вами в ближайшее время.
            </p>
          </div>

          <!-- Форма -->
          <form v-else class="cf-form" data-reveal style="--reveal-delay: 150ms" @submit.prevent="submit">
            <!-- Имя -->
            <div class="cf-field">
              <label class="cf-label" for="lead-name">Имя *</label>
              <input
                id="lead-name"
                v-model="form.name"
                type="text"
                class="cf-input"
                placeholder="Как к вам обращаться"
                autocomplete="name"
              />
              <p v-if="errors.name" class="cf-error">{{ errors.name }}</p>
            </div>

            <!-- Контакты: email + телефон -->
            <div class="grid gap-7 sm:grid-cols-2 sm:gap-6">
              <div class="cf-field">
                <label class="cf-label" for="lead-email">Email</label>
                <input
                  id="lead-email"
                  v-model="form.email"
                  type="email"
                  class="cf-input"
                  placeholder="you@example.com"
                  autocomplete="email"
                />
                <p v-if="errors.email" class="cf-error">{{ errors.email }}</p>
              </div>
              <div class="cf-field">
                <label class="cf-label" for="lead-phone">Телефон</label>
                <input
                  id="lead-phone"
                  v-model="form.phone"
                  type="tel"
                  class="cf-input"
                  placeholder="+7 ..."
                  autocomplete="tel"
                />
                <p v-if="errors.phone" class="cf-error">{{ errors.phone }}</p>
              </div>
            </div>
            <p v-if="errors.contact" class="cf-error -mt-3">{{ errors.contact }}</p>

            <!-- Услуга -->
            <div v-if="serviceOptions.length" class="cf-field">
              <label class="cf-label" for="lead-service">Интересует услуга</label>
              <div class="relative">
                <select id="lead-service" v-model="form.service" class="cf-input appearance-none pr-8">
                  <option :value="''" disabled>Выберите услугу</option>
                  <option v-for="opt in serviceOptions" :key="opt.value" :value="opt.value">
                    {{ opt.label }}
                  </option>
                </select>
                <UIcon
                  name="i-lucide-chevron-down"
                  class="pointer-events-none absolute top-1/2 right-1 h-4 w-4 -translate-y-1/2 text-[var(--color-ink-subtle)]"
                  aria-hidden="true"
                />
              </div>
            </div>

            <!-- Сообщение -->
            <div class="cf-field">
              <label class="cf-label" for="lead-message">О проекте *</label>
              <textarea
                id="lead-message"
                v-model="form.message"
                class="cf-input cf-textarea"
                rows="3"
                placeholder="Тип помещения, площадь, сроки, пожелания..."
              />
              <p v-if="errors.message" class="cf-error">{{ errors.message }}</p>
            </div>

            <!-- Согласие -->
            <div class="cf-field">
              <label class="flex items-start gap-3 text-sm" :class="isDark ? 'text-[#f6f1e7]/60' : 'text-[var(--color-ink-muted)]'">
                <input v-model="form.consent" type="checkbox" class="cf-checkbox mt-0.5" />
                <span>
                  Согласен с
                  <NuxtLink to="/privacy" class="underline underline-offset-2 hover:text-[var(--color-ink)]">политикой обработки персональных данных</NuxtLink>
                </span>
              </label>
              <p v-if="errors.consent" class="cf-error">{{ errors.consent }}</p>
            </div>

            <!-- Ошибка -->
            <div v-if="error" class="cf-error-box">
              {{ error }}
            </div>

            <button type="submit" class="btn-pill mt-2 w-full justify-between" :disabled="pending">
              <span>{{ pending ? 'Отправляем...' : 'Отправить заявку' }}</span>
              <span class="btn-pill-orb" aria-hidden="true">
                <UIcon v-if="pending" name="i-lucide-loader-circle" class="h-4 w-4 animate-spin" />
                <svg v-else viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" class="h-3.5 w-3.5">
                  <path d="M7 17 17 7" />
                  <path d="M8 7h9v9" />
                </svg>
              </span>
            </button>
          </form>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Поля с hairline-подчёркиванием — как email-строка футера ayocin */
.cf {
  color: var(--color-ink);
}

.cf-form {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.cf-field {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.cf-label {
  font-size: 0.6875rem;
  font-weight: 500;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: var(--color-ink-muted);
}

.cf-input {
  width: 100%;
  border: none;
  border-bottom: 1px solid var(--color-line);
  background: transparent;
  padding: 0.75rem 0;
  font-size: 1.0625rem;
  line-height: 1.4;
  color: var(--color-ink);
  border-radius: 0;
  transition: border-color var(--duration-base) var(--ease-premium);
}

.cf-input::placeholder {
  color: var(--color-ink-subtle);
}

.cf-input:focus {
  outline: none;
  border-bottom-color: var(--color-ink);
}

.cf-textarea {
  resize: vertical;
  min-height: 5.5rem;
}

.cf--dark .cf-label,
.cf--dark .cf-input::placeholder {
  color: color-mix(in srgb, #f6f1e7 55%, transparent);
}

.cf--dark .cf-input {
  border-bottom-color: rgba(246, 241, 231, 0.25);
  color: #f6f1e7;
}

.cf--dark .cf-input:focus {
  border-bottom-color: #f6f1e7;
}

/* Чекбокс — квадрат с тонкой рамкой, акцент при выборе */
.cf-checkbox {
  height: 1.125rem;
  width: 1.125rem;
  appearance: none;
  flex-shrink: 0;
  border: 1px solid var(--color-line);
  border-radius: 4px;
  background: transparent;
  cursor: pointer;
  transition: background-color var(--duration-fast) var(--ease-premium),
    border-color var(--duration-fast) var(--ease-premium);
}

.cf-checkbox:checked {
  background-color: var(--color-ink);
  border-color: var(--color-ink);
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23f6f1e7' stroke-width='3' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M20 6 9 17l-5-5'/%3E%3C/svg%3E");
  background-size: 0.75rem;
  background-position: center;
  background-repeat: no-repeat;
}

.cf--dark .cf-checkbox {
  border-color: rgba(246, 241, 231, 0.3);
}

.cf--dark .cf-checkbox:checked {
  background-color: #f6f1e7;
  border-color: #f6f1e7;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23292019' stroke-width='3' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M20 6 9 17l-5-5'/%3E%3C/svg%3E");
}

.cf-checkbox:focus-visible {
  outline: 2px solid var(--color-ink);
  outline-offset: 2px;
}

.cf-error {
  font-size: 0.75rem;
  color: var(--color-error);
}

.cf-error-box {
  border-left: 2px solid var(--color-error);
  padding: 0.75rem 1rem;
  font-size: 0.875rem;
  color: var(--color-error);
}
</style>
