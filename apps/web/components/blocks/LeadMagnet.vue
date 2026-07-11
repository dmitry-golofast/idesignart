<script setup lang="ts">
import { computed } from 'vue'

/**
 * LeadMagnet — полоса сбора email в обмен на PDF-гид.
 * Конверсионный элемент: собирает контакты даже у нерешительных клиентов.
 *
 * Контент гида (заголовок, подзаголовок, изображение, файл) —
 * из Payload Settings.leadMagnet. Включается флагом enabled.
 *
 * Размещается на главной (между отзывами и финальным CTA),
 * а также может вызываться отдельно на любой странице.
 */

const props = withDefaults(defineProps<{
  source?: string
  leadMagnetSlug?: string
}>(), {
  source: 'lead-magnet-home',
  leadMagnetSlug: 'design-guide',
})

// Тянем настройки — там хранится контент гида
const { data: settingsData } = useSettings()
const settings = computed(() => settingsData.value?.value?.leadMagnet)

// Не рендерим, если лид-магнит выключен в настройках
const enabled = computed(() => settings.value?.enabled !== false)

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

const guideImage = computed(() => {
  const url = settings.value?.image?.url
  if (!url) return ''
  return url.startsWith('http') ? url : `${payloadBase}${url}`
})

const { form, submit, pending, success, error, errors, downloadUrl } = useSubscription({
  source: props.source,
  leadMagnet: props.leadMagnetSlug,
})
</script>

<template>
  <section v-if="enabled" class="section bg-[var(--color-accent-soft)]">
    <div class="container-app">
      <div class="grid items-center gap-12 lg:grid-cols-2 lg:gap-20">
        <!-- Левая часть: изображение гида -->
        <div v-if="guideImage" class="order-2 lg:order-1">
          <div class="relative">
            <div class="absolute inset-0 rotate-3 rounded-[var(--radius-lg)] bg-[var(--color-accent)]/20" />
            <NuxtImg
              :src="guideImage"
              :alt="settings?.title || 'Гид по дизайну интерьера'"
              class="relative w-full rounded-[var(--radius-lg)] shadow-[var(--shadow-hover)]"
              sizes="(max-width: 1024px) 100vw, 480px"
              format="webp,avif"
            />
          </div>
        </div>

        <!-- Правая часть: текст + форма -->
        <div class="order-1 lg:order-2">
          <p class="eyebrow">Бесплатно</p>
          <h2 class="mt-3 font-display text-[var(--text-h2)] text-[var(--color-ink)]">
            {{ settings?.title || 'Гид: 10 вопросов перед началом ремонта' }}
          </h2>
          <p class="mt-4 max-w-md text-[var(--color-ink-muted)]">
            {{ settings?.subtitle || 'PDF-чек-лист, который сэкономит время, нервы и деньги. Скачайте бесплатно — оставьте email.' }}
          </p>

          <!-- Состояние успеха -->
          <div v-if="success" class="mt-8 rounded-[var(--radius-lg)] bg-[var(--color-surface)] p-6 shadow-[var(--shadow-card)]">
            <div class="flex items-center gap-3">
              <UIcon name="i-lucide-check-circle" class="h-8 w-8 text-[var(--color-success)]" />
              <div>
                <p class="font-medium text-[var(--color-ink)]">Готово! Гид отправлен.</p>
                <p class="text-sm text-[var(--color-ink-muted)]">Проверьте почту (и папку «Промо»).</p>
              </div>
            </div>
            <UButton
              v-if="downloadUrl"
              :to="downloadUrl"
              color="primary"
              size="lg"
              class="mt-4 w-full justify-center"
              external
              target="_blank"
              download
              icon="i-lucide-download"
            >
              Скачать PDF
            </UButton>
          </div>

          <!-- Форма -->
          <form v-else class="mt-8 space-y-4" @submit.prevent="submit">
            <div class="grid gap-4 sm:grid-cols-[1fr_auto]">
              <UInput
                v-model="form.email"
                type="email"
                placeholder="your@email.com"
                size="xl"
                class="w-full"
                :class="errors.email ? 'ring-2 ring-[var(--color-error)]/30' : ''"
              />
              <UButton
                type="submit"
                color="primary"
                size="xl"
                :loading="pending"
                class="justify-center"
              >
                Получить гид
              </UButton>
            </div>

            <!-- Имя (опционально) -->
            <UInput
              v-model="form.name"
              placeholder="Имя (необязательно)"
              size="md"
              class="w-full"
            />

            <p v-if="errors.email" class="text-xs text-[var(--color-accent-deep)]">{{ errors.email }}</p>

            <!-- Согласие -->
            <label class="flex items-start gap-3 text-sm text-[var(--color-ink-muted)]">
              <UCheckbox v-model="form.consent" class="mt-0.5" />
              <span>
                Согласен с
                <NuxtLink to="/privacy" class="underline hover:text-[var(--color-accent)]">политикой обработки данных</NuxtLink>
                и получением писем.
              </span>
            </label>
            <p v-if="errors.consent" class="-mt-2 text-xs text-[var(--color-accent-deep)]">{{ errors.consent }}</p>

            <div v-if="error" class="rounded-[var(--radius-md)] bg-[var(--color-surface)] p-3 text-sm text-[var(--color-accent-deep)]">
              {{ error }}
            </div>
          </form>
        </div>
      </div>
    </div>
  </section>
</template>
