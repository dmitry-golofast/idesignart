<script setup lang="ts">
import { computed } from 'vue'
import type { Category, Media, Project } from '#shared/types/payload'

/**
 * PortfolioProjectCard — кликабельная карточка проекта.
 * Используется в BlocksPortfolioMasonry: вся карточка — ссылка на кейс,
 * «Подробнее» внутри — декоративная подсказка (без вложенных ссылок).
 */
const props = defineProps<{
  project: Project
  cover: Media | null
  /** srcset sizes — зависит от слота в сетке (крупный / малый) */
  sizes?: string
  /** Крупная карточка — больше типографика */
  large?: boolean
}>()

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

const propertyLabels: Record<string, string> = {
  apartment: 'Квартиры',
  house: 'Частные дома',
  office: 'Коммерческие',
  retail: 'Коммерческие',
  hospitality: 'HoReCa',
  other: 'Другой объект',
}

/**
 * Плашка типа объекта: категория проекта из CMS,
 * при отсутствии — тип из метаданных проекта.
 */
const badge = computed(() => {
  const categories = (props.project.categories ?? []).filter(
    (c): c is Category => Boolean(c) && typeof c === 'object',
  )
  if (categories[0]?.title) return categories[0].title
  const pt = props.project.meta?.propertyType
  return pt ? propertyLabels[pt] : null
})
</script>

<template>
  <NuxtLink
    :to="`/portfolio/${project.slug}`"
    :aria-label="`Открыть проект ${project.title}`"
    class="group relative block overflow-hidden rounded-xl bg-[var(--color-surface-alt)]"
  >
    <!-- Обложка: лёгкий zoom на hover (спека §07.72).
         sizes — только префиксный синтаксис nuxt/image (lg:60vw): CSS-строки
         "(min-width: …)" v1 не парсит и генерирует srcset 1px/2px → «пятно» -->
    <NuxtImg
      v-if="cover?.url"
      data-marker="card-v2"
      :src="cover.url.startsWith('http') ? cover.url : `${payloadBase}${cover.url}`"
      :alt="cover.alt || project.title"
      :sizes="sizes || 'md:50vw 100vw'"
      format="webp,avif"
      class="absolute inset-0 h-full w-full object-cover transition-transform duration-300 ease-out group-hover:scale-[1.03]"
    />

    <!-- Градиент снизу — всегда, для читаемости на светлых и тёмных фото -->
    <div
      class="absolute inset-0 bg-gradient-to-t from-black/75 via-black/25 to-transparent transition-opacity duration-300 group-hover:from-black/85"
      aria-hidden="true"
    />

    <!-- Плашка с типом объекта -->
    <span
      v-if="badge"
      class="absolute top-4 left-4 rounded-[var(--radius-pill)] bg-[var(--color-canvas)]/90 px-3 py-1 text-xs font-medium text-[var(--color-ink)] backdrop-blur-sm"
    >
      {{ badge }}
    </span>

    <!-- Нижняя зона: название и описание слева, площадь и «Подробнее» справа -->
    <div class="absolute inset-x-0 bottom-0 flex items-end justify-between gap-4 p-5 sm:p-6">
      <div class="min-w-0">
        <!-- Названия проектов в макете — жирный гротеск (не сериф) -->
        <h3
          class="font-sans font-bold text-white"
          :class="large ? 'text-2xl sm:text-[28px]' : 'text-lg sm:text-xl'"
        >
          {{ project.title }}
        </h3>
        <p v-if="project.excerpt" class="mt-1.5 line-clamp-2 max-w-md text-sm text-white/80 sm:text-[15px]">
          {{ project.excerpt }}
        </p>
      </div>

      <div class="shrink-0 text-right">
        <p v-if="project.meta?.area" class="text-sm font-semibold text-white sm:text-base">
          {{ project.meta.area }} м²
        </p>
        <!-- «Подробнее» с горизонтальной стрелкой и подчёркиванием (по макету) -->
        <span class="mt-1 inline-flex items-center gap-1.5 text-xs font-medium text-white/90 underline decoration-white/50 underline-offset-4 transition-colors duration-200 group-hover:decoration-white sm:text-sm">
          Подробнее
          <UIcon name="i-lucide-arrow-right" class="h-3.5 w-3.5 sm:h-4 sm:w-4" aria-hidden="true" />
        </span>
      </div>
    </div>
  </NuxtLink>
</template>
