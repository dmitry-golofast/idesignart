<script setup lang="ts">
import { computed, ref } from 'vue'
import type { Category, Project } from '#shared/types/payload'

/**
 * PortfolioMasonry — блок «Наши работы» (редизайн v3, язык ayocin).
 *
 * Editorial-шапка: номер главы + заголовок + hairline, справа —
 * факт-метрики с иконками-кольцами. Фильтры — пилюли-чипы
 * (активная — эспрессо-заливка). Сетка «1 крупный + 2 компактных»
 * сохранена, появление — stagger при скролле.
 */
const props = defineProps<{
  projects?: (Project | number)[] | null
  title?: string
  eyebrow?: string
  limit?: number
  showFilters?: boolean
  facts?: { icon?: string | null; value?: string | null; label?: string | null }[] | null
  /** Номер главы — присваивается по порядку блоков на странице (PageSections) */
  num?: number
}>()

const secNum = computed(() => String(props.num ?? 1).padStart(2, '0'))

/**
 * Проекты, выбранные вручную в админке (depth=3 отдаёт их объектами
 * в заданном порядке). Если они есть — авто-режим не используется.
 */
const manualProjects = computed(() =>
  (props.projects ?? []).filter((p): p is Project =>
    Boolean(p) && typeof p === 'object' && 'slug' in p,
  ),
)

const { data } = useProjects({ featured: manualProjects.value.length === 0, limit: props.limit || 6 })
const allProjects = computed(() =>
  manualProjects.value.length ? manualProjects.value : (data.value?.docs || []),
)

/**
 * Фильтры — категории типа «Проект» из CMS,
 * фильтрация клиентская, без перезагрузки страницы.
 */
const { data: categoriesData } = usePayload<{ docs: Category[] }>('categories', {
  where: payloadWhere({ type: { equals: 'project' } }),
  limit: '20',
  sort: 'order',
})
const categories = computed(() => categoriesData.value?.docs ?? [])

const activeSlug = ref<string | null>(null) // null = «Все»

const visibleProjects = computed(() => {
  if (!activeSlug.value) return allProjects.value
  return allProjects.value.filter(p =>
    (p.categories ?? []).some(c => typeof c === 'object' && c !== null && c.slug === activeSlug.value),
  )
})

/**
 * Раскладка сетки: первый проект — крупный слева, ещё два — справа,
 * остальные — ниже обычной сеткой.
 */
const feature = computed(() => visibleProjects.value[0])
const side = computed(() => visibleProjects.value.slice(1, 3))
const rest = computed(() => visibleProjects.value.slice(3))

/**
 * Факт-метрики справа от заголовка (язык ayocin: icon-ring + текст).
 * Значения по умолчанию — демонстрационные, редактируются в админке.
 */
interface FactCard {
  icon: string
  value: string
  label: string
}

const DEFAULT_FACTS: FactCard[] = [
  { icon: 'layers', value: '120+', label: 'реализованных проектов' },
  { icon: 'house', value: 'Квартиры, дома, коммерческие', label: 'все типы пространств' },
  { icon: 'leaf', value: 'Полный цикл', label: 'от концепции до реализации' },
]

const factCards = computed<FactCard[]>(() => {
  const fromCms = (props.facts ?? []).flatMap(f =>
    f.value && f.label ? [{ icon: f.icon ?? 'layers', value: f.value, label: f.label }] : [],
  )
  return fromCms.length ? fromCms : DEFAULT_FACTS
})

const factIcons: Record<string, string> = {
  layers: 'i-lucide-layers',
  house: 'i-lucide-house',
  leaf: 'i-lucide-leaf',
  compass: 'i-lucide-compass',
}
</script>

<template>
  <section class="section section-full">
    <div class="container-app">
      <!-- Editorial-шапка: номер + заголовок + hairline -->
      <div class="sec-head" data-reveal>
        <span class="sec-num" aria-hidden="true">{{ secNum }}</span>
        <h2 id="works-title" class="sec-title">{{ title || 'Наши работы' }}</h2>
      </div>

      <!-- Строка под шапкой: фильтры слева, факт-метрики справа -->
      <div class="mt-6 flex flex-col gap-6 lg:flex-row lg:items-start lg:justify-between">
        <!-- Фильтры-чипы: категории типа «Проект» из CMS -->
        <div
          v-if="showFilters !== false && categories.length"
          class="flex gap-2 overflow-x-auto pb-1 sm:flex-wrap sm:overflow-visible"
          role="group"
          aria-label="Фильтр проектов по типу объекта"
          data-reveal
          style="--reveal-delay: 100ms"
        >
          <button
            type="button"
            :aria-pressed="activeSlug === null"
            class="chip-filter shrink-0"
            @click="activeSlug = null"
          >
            Все
          </button>
          <button
            v-for="c in categories"
            :key="c.id"
            type="button"
            :aria-pressed="activeSlug === c.slug"
            class="chip-filter shrink-0"
            @click="activeSlug = c.slug"
          >
            {{ c.title }}
          </button>
        </div>

        <!-- Факт-метрики: иконка-кольцо + значение + подпись -->
        <ul
          v-if="factCards.length"
          class="grid shrink-0 gap-5 sm:grid-cols-3 lg:max-w-xl lg:gap-8"
          data-reveal="fade"
          style="--reveal-delay: 200ms"
        >
          <li v-for="(f, i) in factCards" :key="i" class="flex flex-col gap-3">
            <span class="icon-ring" aria-hidden="true">
              <UIcon :name="factIcons[f.icon] || factIcons.layers" class="h-4.5 w-4.5" />
            </span>
            <div>
              <p class="text-[15px] leading-snug font-medium text-[var(--color-ink)]">{{ f.value }}</p>
              <p class="mt-1 text-xs leading-snug text-[var(--color-ink-muted)]">{{ f.label }}</p>
            </div>
          </li>
        </ul>
      </div>

      <!-- Сетка проектов: 1 крупный + 2 компактных, остальные ниже -->
      <template v-if="visibleProjects.length">
        <div class="mt-8 grid gap-4 md:grid-cols-[1.63fr_1fr] md:grid-rows-2 lg:gap-5">
          <BlocksPortfolioProjectCard
            v-if="feature"
            :project="feature"
            :cover="populated(feature.coverImage)"
            :large="true"
            :sizes="'lg:60vw 100vw'"
            class="h-[300px] sm:h-[380px] md:row-span-2 md:h-auto"
            :class="side.length === 0 ? 'md:col-span-2 md:min-h-[380px]' : ''"
            data-reveal="zoom"
          />
          <BlocksPortfolioProjectCard
            v-for="(p, i) in side"
            :key="p.id"
            :project="p"
            :cover="populated(p.coverImage)"
            :sizes="'lg:38vw 100vw'"
            class="h-[300px] md:col-start-2"
            :class="[
              i === 0 ? 'md:row-start-1' : 'md:row-start-2',
              side.length === 1 ? 'md:row-span-2 md:h-auto md:min-h-[240px]' : 'md:h-[172px]',
            ]"
            data-reveal="zoom"
            :style="{ '--reveal-delay': `${(i + 1) * 130}ms` }"
          />
        </div>

        <div v-if="rest.length" class="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-3 lg:gap-5">
          <BlocksPortfolioProjectCard
            v-for="(p, i) in rest"
            :key="p.id"
            :project="p"
            :cover="populated(p.coverImage)"
            :sizes="'sm:50vw lg:33vw 100vw'"
            class="h-[300px]"
            data-reveal
            :style="{ '--reveal-delay': `${(i % 3) * 110}ms` }"
          />
        </div>
      </template>

      <!-- Пустая категория -->
      <div
        v-else
        class="mt-10 rounded-[var(--radius-lg)] border border-dashed border-[var(--color-line)] px-6 py-12 text-center"
      >
        <p class="text-[var(--color-ink-muted)]">В этой категории пока нет проектов.</p>
        <button type="button" class="link-arrow mt-3 text-sm" @click="activeSlug = null">
          Показать все проекты
        </button>
      </div>
    </div>
  </section>
</template>
