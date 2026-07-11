<script setup lang="ts">
import { computed } from 'vue'

/**
 * ContactForm — основная форма захвата лидов.
 * Валидация через useLeadForm (zod), отправка в Payload (коллекция leads).
 *
 * Референс: Studio McNeely — множественные формы захвата по сайту.
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
const serviceOptions = computed(() =>
  (servicesData.value?.docs || []).map((s) => ({
    label: s.title,
    value: s.id,
  })),
)

const { form, submit, pending, success, error, errors } = useLeadForm()

// Применяем defaults из props
if (props.defaultService) form.service = props.defaultService
if (props.source) form.source = props.source

const inputClass = 'w-full rounded-[var(--radius-md)] border-[var(--color-line)] bg-[var(--color-surface)] px-4 py-3 text-[var(--color-ink)] placeholder:text-[var(--color-ink-subtle)] focus:border-[var(--color-accent)] focus:ring-2 focus:ring-[var(--color-accent)]/20'
const labelClass = 'mb-1.5 block text-sm font-medium'

const isDark = computed(() => props.variant === 'dark')
</script>

<template>
  <section
    class="section"
    :class="isDark ? 'bg-[var(--color-ink)] text-[var(--color-canvas)]' : 'bg-[var(--color-canvas)]'"
  >
    <div class="container-app">
      <div class="grid gap-12 lg:grid-cols-2 lg:gap-20">
        <!-- Левая колонка — текст -->
        <div>
          <p class="eyebrow">{{ eyebrow || 'Связаться' }}</p>
          <h2 class="mt-3 font-display text-[var(--text-h2)]" :class="isDark ? 'text-[var(--color-canvas)]' : ''">
            {{ title || 'Расскажите о вашем проекте' }}
          </h2>
          <p
            class="mt-4 max-w-md"
            :class="isDark ? 'text-[var(--color-canvas)]/70' : 'text-[var(--color-ink-muted)]'"
          >
            {{ description || 'Ответим в течение рабочего дня. Консультация — бесплатно.' }}
          </p>

          <!-- Доп. контакты -->
          <div v-if="!isDark" class="mt-8 space-y-3">
            <div class="flex items-center gap-3 text-sm text-[var(--color-ink-muted)]">
              <UIcon name="i-lucide-clock" class="h-5 w-5 text-[var(--color-accent)]" />
              <span>Ответ в течение рабочего дня</span>
            </div>
            <div class="flex items-center gap-3 text-sm text-[var(--color-ink-muted)]">
              <UIcon name="i-lucide-shield-check" class="h-5 w-5 text-[var(--color-accent)]" />
              <span>Договор и фиксированная смета</span>
            </div>
            <div class="flex items-center gap-3 text-sm text-[var(--color-ink-muted)]">
              <UIcon name="i-lucide-map-pin" class="h-5 w-5 text-[var(--color-accent)]" />
              <span>Работаем по городу и удалённо</span>
            </div>
          </div>
        </div>

        <!-- Правая колонка — форма -->
        <div>
          <!-- Состояние успеха -->
          <div
            v-if="success"
            class="flex flex-col items-center rounded-[var(--radius-lg)] border border-[var(--color-success)]/30 bg-[var(--color-success)]/5 p-12 text-center"
          >
            <div class="mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-[var(--color-success)]/10 text-[var(--color-success)]">
              <UIcon name="i-lucide-check" class="h-8 w-8" />
            </div>
            <h3 class="font-display text-2xl text-[var(--color-ink)]">Заявка отправлена!</h3>
            <p class="mt-2 text-[var(--color-ink-muted)]">
              Спасибо! Свяжемся с вами в ближайшее время.
            </p>
          </div>

          <!-- Форма -->
          <form
            v-else
            class="space-y-5"
            @submit.prevent="submit"
          >
            <!-- Имя -->
            <div>
              <label :class="labelClass" for="lead-name">Имя *</label>
              <UInput
                id="lead-name"
                v-model="form.name"
                placeholder="Как к вам обращаться"
                size="lg"
                class="w-full"
              />
              <p v-if="errors.name" class="mt-1 text-xs text-[var(--color-error)]">{{ errors.name }}</p>
            </div>

            <!-- Контакты: email + телефон -->
            <div class="grid gap-5 sm:grid-cols-2">
              <div>
                <label :class="labelClass" for="lead-email">Email</label>
                <UInput
                  id="lead-email"
                  v-model="form.email"
                  type="email"
                  placeholder="you@example.com"
                  size="lg"
                  class="w-full"
                />
                <p v-if="errors.email" class="mt-1 text-xs text-[var(--color-error)]">{{ errors.email }}</p>
              </div>
              <div>
                <label :class="labelClass" for="lead-phone">Телефон</label>
                <UInput
                  id="lead-phone"
                  v-model="form.phone"
                  type="tel"
                  placeholder="+7 ..."
                  size="lg"
                  class="w-full"
                />
                <p v-if="errors.phone" class="mt-1 text-xs text-[var(--color-error)]">{{ errors.phone }}</p>
              </div>
            </div>
            <p v-if="errors.contact" class="-mt-3 text-xs text-[var(--color-error)]">{{ errors.contact }}</p>

            <!-- Услуга -->
            <div v-if="serviceOptions.length">
              <label :class="labelClass" for="lead-service">Интересует услуга</label>
              <USelect
                id="lead-service"
                v-model="form.service"
                :items="serviceOptions"
                placeholder="Выберите услугу"
                size="lg"
                class="w-full"
              />
            </div>

            <!-- Сообщение -->
            <div>
              <label :class="labelClass" for="lead-message">О проекте *</label>
              <UTextarea
                id="lead-message"
                v-model="form.message"
                placeholder="Тип помещения, площадь, сроки, пожелания..."
                :rows="4"
                size="lg"
                class="w-full"
              />
              <p v-if="errors.message" class="mt-1 text-xs text-[var(--color-error)]">{{ errors.message }}</p>
            </div>

            <!-- Согласие -->
            <div>
              <label class="flex items-start gap-3 text-sm text-[var(--color-ink-muted)]">
                <UCheckbox v-model="form.consent" class="mt-0.5" />
                <span>
                  Согласен с
                  <NuxtLink to="/privacy" class="underline hover:text-[var(--color-accent)]">политикой обработки персональных данных</NuxtLink>
                </span>
              </label>
              <p v-if="errors.consent" class="mt-1 text-xs text-[var(--color-error)]">{{ errors.consent }}</p>
            </div>

            <!-- Ошибка -->
            <div v-if="error" class="rounded-[var(--radius-md)] bg-[var(--color-error)]/10 p-3 text-sm text-[var(--color-error)]">
              {{ error }}
            </div>

            <UButton type="submit" size="xl" color="primary" class="w-full justify-center" :loading="pending">
              Отправить заявку
            </UButton>
          </form>
        </div>
      </div>
    </div>
  </section>
</template>
