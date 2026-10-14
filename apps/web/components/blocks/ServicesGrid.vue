<script setup lang="ts">
import { computed } from 'vue'
import type { Service } from '#shared/types/payload'

/**
 * ServicesGrid — блок «Чем мы можем помочь» (редизайн v3.1).
 *
 * Стиль карточек — референс ayocin «2. Smart Air Cleaning»:
 * скруглённая панель с изображением и тёмным кружком-буквой (A, B, C…)
 * в левом верхнем углу, под панелью — caps-метка с буллитом (tagline)
 * и крупный заголовок услуги. Вся карточка — ссылка.
 *
 * Данные: услуги из Payload через useServices() либо через props.
 */
const props = defineProps<{
  services?: Service[]
  title?: string
  description?: string
  /** Номер главы — присваивается по порядку блоков на странице (PageSections) */
  num?: number
}>()

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

const secNum = computed(() => String(props.num ?? 1).padStart(2, '0'))

// Если услуги не переданы — тянем опубликованные featured.
// cardImage — связь Payload (number | Media), сужаем до объекта для шаблона.
const { data } = useServices({ featuredOnly: !props.services?.length })
const services = computed(() =>
  (props.services?.length ? props.services : (data.value?.docs || []))
    .map((s) => ({ ...s, cardImage: populated(s.cardImage) })),
)

/** Буквенные индексы A/B/C… на панелях — как у ayocin */
const LETTERS = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
const letter = (i: number) => LETTERS[i] ?? String(i + 1)
</script>

<template>
  <section class="section section-full">
    <div class="container-app">
      <!-- Editorial-шапка: номер главы + заголовок во всю ширину + hairline -->
      <div class="sec-head" data-reveal>
        <span class="sec-num" aria-hidden="true">{{ secNum }}</span>
        <h2 class="sec-title">{{ title || 'Чем мы можем помочь' }}</h2>
      </div>
      <p
        v-if="description"
        class="mt-4 max-w-md text-[15px] leading-relaxed text-[var(--color-ink-muted)]"
        data-reveal="fade"
        style="--reveal-delay: 120ms"
      >
        {{ description }}
      </p>

      <!-- Карточки-панели: одинаковые, в ряд (ayocin Smart Air Cleaning) -->
      <div class="mt-10 grid gap-x-5 gap-y-12 sm:grid-cols-2 lg:grid-cols-3">
        <NuxtLink
          v-for="(service, i) in services"
          :key="service.id"
          :to="`/services/${service.slug}`"
          :aria-label="`Подробнее: ${service.title}`"
          class="group flex flex-col"
          data-reveal
          :style="{ '--reveal-delay': `${(i % 3) * 110}ms` }"
        >
          <!-- Панель с изображением и буквой-бейджем -->
          <div class="relative aspect-[10/9] overflow-hidden rounded-[var(--radius-lg)] bg-[var(--color-surface-alt)]">
            <NuxtImg
              v-if="service.cardImage?.url"
              :src="service.cardImage.url.startsWith('http') ? service.cardImage.url : `${payloadBase}${service.cardImage.url}`"
              :alt="service.cardImage.alt || service.title"
              :sizes="'lg:33vw 100vw'"
              format="webp,avif"
              class="absolute inset-0 h-full w-full object-cover transition-transform duration-700 ease-[var(--ease-premium)] group-hover:scale-[1.04]"
            />
            <!-- Фолбэк без фото: призрачная буква на панели -->
            <span
              v-else
              class="absolute inset-0 flex items-center justify-center text-8xl font-bold tracking-[-0.02em] text-[var(--color-ink-subtle)]/35"
              aria-hidden="true"
            >
              {{ letter(i) }}
            </span>

            <!-- Буква-бейдж в тёмном кружке -->
            <span
              class="absolute top-4 left-4 flex h-9 w-9 items-center justify-center rounded-full bg-[var(--color-accent)] text-sm font-medium text-[var(--color-accent-contrast)]"
              aria-hidden="true"
            >
              {{ letter(i) }}
            </span>
          </div>

          <!-- caps-метка + крупный заголовок под панелью -->
          <p
            v-if="service.tagline"
            class="meta-label mt-5 !text-[var(--color-ink)]"
          >
            {{ service.tagline }}
          </p>
          <h3 class="mt-2 max-w-sm text-2xl leading-[1.15] font-bold tracking-[-0.02em] text-[var(--color-ink)] sm:text-[26px]">
            {{ service.title }}
          </h3>
        </NuxtLink>
      </div>
    </div>
  </section>
</template>
