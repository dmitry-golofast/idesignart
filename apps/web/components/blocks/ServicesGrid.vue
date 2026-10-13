<script setup lang="ts">
import { computed } from 'vue'
import type { Service } from '#shared/types/payload'

/**
 * ServicesGrid — блок «Чем мы можем помочь» (спека по макету).
 *
 * Фото-карточки: снимок сверху с номером-плашкой, под ним название
 * и caps-подзаголовок (tagline), справа — лаймовая круглая стрелка.
 * Сетка: первые три карточки в 3 колонки, остальные — широкими
 * во 2-м ряду. Единый язык с блоком «Наши работы».
 *
 * Данные: услуги из Payload через useServices() либо через props.
 * Фото и tagline — связи/поля коллекции services (cardImage, tagline).
 */
const props = defineProps<{
  services?: Service[]
  title?: string
  description?: string
}>()

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

// Если услуги не переданы — тянем опубликованные featured.
// cardImage — связь Payload (number | Media), сужаем до объекта для шаблона.
const { data } = useServices({ featuredOnly: !props.services?.length })
const services = computed(() =>
  (props.services?.length ? props.services : (data.value?.docs || []))
    .map((s) => ({ ...s, cardImage: populated(s.cardImage) })),
)
</script>

<template>
  <section class="section">
    <div class="container-app">
      <!-- Шапка: слева заголовок, справа описание (по макету, без надзаголовка) -->
      <div class="flex flex-col gap-6 lg:flex-row lg:items-start lg:justify-between">
        <h2 class="section-title max-w-2xl">
          {{ title || 'Чем мы можем помочь' }}
        </h2>
        <p
          v-if="description"
          class="max-w-sm shrink-0 text-[15px] leading-relaxed text-[var(--color-ink-muted)] lg:mt-2"
        >
          {{ description }}
        </p>
      </div>

      <!-- Сетка: 3 + 2 широких (lg: 6 колонок, span 2/3) -->
      <div class="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-6">
        <NuxtLink
          v-for="(service, i) in services"
          :key="service.id"
          :to="`/services/${service.slug}`"
          :aria-label="`Подробнее: ${service.title}`"
          class="group flex flex-col rounded-[var(--radius-lg)] border border-[var(--color-line)] bg-[var(--color-surface)] p-3 shadow-[var(--shadow-card)] transition-shadow duration-300 hover:shadow-[var(--shadow-hover)]"
          :class="i < 3 ? 'lg:col-span-2' : 'lg:col-span-3'"
        >
          <!-- Снимок с номером-плашкой; лёгкий zoom на hover — как в «Наших работах» -->
          <div
            class="relative overflow-hidden rounded-[10px] bg-[var(--color-surface-alt)]"
            :class="i < 3 ? 'aspect-[7/5]' : 'aspect-[7/5] lg:aspect-[2/1]'"
          >
            <NuxtImg
              v-if="service.cardImage?.url"
              :src="service.cardImage.url.startsWith('http') ? service.cardImage.url : `${payloadBase}${service.cardImage.url}`"
              :alt="service.cardImage.alt || service.title"
              :sizes="'lg:40vw 100vw'"
              format="webp,avif"
              class="absolute inset-0 h-full w-full object-cover transition-transform duration-500 ease-out group-hover:scale-[1.04]"
            />
            <!-- Фолбэк без фото: призрачный номер на нейтральном фоне -->
            <span
              v-else
              class="absolute inset-0 flex items-center justify-center text-6xl font-extrabold tracking-[-0.03em] text-[var(--color-ink-subtle)]/40"
              aria-hidden="true"
            >
              {{ String(i + 1).padStart(2, '0') }}
            </span>

            <span
              class="absolute top-4 left-4 rounded-lg bg-[var(--color-canvas)]/95 px-3 py-1.5 text-[13px] leading-none font-semibold text-[var(--color-ink)] backdrop-blur-sm"
            >
              {{ String(i + 1).padStart(2, '0') }}
            </span>
          </div>

          <!-- Название + caps-подзаголовок слева, лаймовая стрелка справа -->
          <div class="flex items-center justify-between gap-4 px-2 pt-4 pb-2 sm:px-3">
            <div class="min-w-0">
              <h3 class="text-xl font-bold tracking-[-0.01em] text-[var(--color-ink)] sm:text-[22px]">
                {{ service.title }}
              </h3>
              <p
                v-if="service.tagline"
                class="mt-1.5 text-xs font-medium tracking-[0.18em] text-[var(--color-ink-muted)] uppercase"
              >
                {{ service.tagline }}
              </p>
            </div>

            <span
              class="flex h-11 w-11 shrink-0 items-center justify-center rounded-full bg-[var(--color-lime)] text-[var(--color-lime-contrast)] transition-transform duration-300 ease-out group-hover:scale-110"
              aria-hidden="true"
            >
              <UIcon
                name="i-lucide-arrow-right"
                class="h-5 w-5 transition-transform duration-300 ease-out group-hover:translate-x-0.5"
              />
            </span>
          </div>
        </NuxtLink>
      </div>
    </div>
  </section>
</template>
