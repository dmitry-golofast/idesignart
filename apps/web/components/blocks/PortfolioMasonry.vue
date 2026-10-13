<script setup lang="ts">
import { computed, ref } from 'vue'
import type { Category, Project } from '#shared/types/payload'

/**
 * PortfolioMasonry — блок «Наши работы» (спека works-section-v3).
 *
 * Шапка: слева заголовок, справа три компактные инфо-карточки
 * (без описательного текста и CTA-кнопки). Ниже — фильтры-чипы
 * и асимметричная сетка «1 крупный проект + 2 компактных справа»,
 * остальные проекты — обычной сеткой под ней.
 *
 * Всё управляется из CMS:
 *  - проекты: ручной выбор в блоке либо авто-режим (featured + limit);
 *  - фильтры: категории типа «Проект» (Контент → Категории);
 *  - факт-карточки: поля блока.
 *
 * На главной показывает выбранные/featured; на /portfolio — все.
 */
const props = defineProps<{
  projects?: (Project | number)[] | null
  title?: string
  eyebrow?: string
  limit?: number
  showFilters?: boolean
  facts?: { icon?: string | null; value?: string | null; label?: string | null }[] | null
}>()

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
 * Фильтры — категории типа «Проект» из CMS (спека §05),
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
 * Инфо-карточки справа от заголовка (спека §04).
 * Значения по умолчанию — демонстрационные, редактируются в админке
 * (блок «Сетка проектов» → «Инфо-карточки»).
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
  <section class="section">
    <div class="container-app">
      <!-- Шапка: слева лейбл + заголовок + фильтры, справа инфо-карточки (по макету) -->
      <div class="flex flex-col gap-8 lg:flex-row lg:items-start lg:justify-between">
        <div class="max-w-xl shrink-0">
          <!-- Лейбл по спеке §18: 12px, 600, caps, широкий трекинг, нейтральный цвет -->
          <p class="text-xs font-semibold tracking-[0.24em] text-[var(--color-ink-muted)] uppercase">
            {{ eyebrow || 'Портфолио' }}
          </p>
          <!-- Заголовок по спеке §20: жирный гротеск, 38–76px, плотный интерлиньяж -->
          <h2
            id="works-title"
            class="mt-3 font-sans text-[clamp(2.375rem,6vw,4.75rem)] leading-[1.04] font-extrabold tracking-[-0.03em] text-[var(--color-ink)]"
          >
            {{ title || 'Наши работы' }}
          </h2>

          <!-- Фильтры-чипы: категории типа «Проект» из CMS, под заголовком -->
          <div
            v-if="showFilters !== false && categories.length"
            class="mt-4 flex gap-2 overflow-x-auto pb-1 sm:flex-wrap sm:overflow-visible"
            role="group"
            aria-label="Фильтр проектов по типу объекта"
          >
            <button
              type="button"
              :aria-pressed="activeSlug === null"
              class="min-h-11 shrink-0 rounded-[var(--radius-pill)] px-5 text-sm font-medium whitespace-nowrap transition-colors duration-200"
              :class="activeSlug === null
                ? 'bg-[var(--color-lime)] text-[var(--color-lime-contrast)]'
                : 'bg-[var(--color-surface-alt)] text-[var(--color-ink)] hover:bg-[var(--color-line)]'"
              @click="activeSlug = null"
            >
              Все
            </button>
            <button
              v-for="c in categories"
              :key="c.id"
              type="button"
              :aria-pressed="activeSlug === c.slug"
              class="min-h-11 shrink-0 rounded-[var(--radius-pill)] px-5 text-sm font-medium whitespace-nowrap transition-colors duration-200"
              :class="activeSlug === c.slug
                ? 'bg-[var(--color-lime)] text-[var(--color-lime-contrast)]'
                : 'bg-[var(--color-surface-alt)] text-[var(--color-ink)] hover:bg-[var(--color-line)]'"
              @click="activeSlug = c.slug"
            >
              {{ c.title }}
            </button>
          </div>
        </div>
      </div>

      <!-- Сетка проектов: 1 крупный + 2 компактных, остальные ниже -->
      <template v-if="visibleProjects.length">
        <div class="mt-6 grid gap-4 md:grid-cols-[1.63fr_1fr] md:grid-rows-2">
          <BlocksPortfolioProjectCard
            v-if="feature"
            :project="feature"
            :cover="populated(feature.coverImage)"
            :large="true"
            :sizes="'lg:60vw 100vw'"
            class="h-[320px] sm:h-[440px] md:row-span-2 md:h-auto"
            :class="side.length === 0 ? 'md:col-span-2 md:min-h-[420px]' : ''"
          />
          <BlocksPortfolioProjectCard
            v-for="(p, i) in side"
            :key="p.id"
            :project="p"
            :cover="populated(p.coverImage)"
            :sizes="'lg:38vw 100vw'"
            class="h-[320px] md:col-start-2"
            :class="[
              i === 0 ? 'md:row-start-1' : 'md:row-start-2',
              side.length === 1 ? 'md:row-span-2 md:h-auto md:min-h-[252px]' : 'md:h-[184px]',
            ]"
          />
        </div>

        <div v-if="rest.length" class="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          <BlocksPortfolioProjectCard
            v-for="p in rest"
            :key="p.id"
            :project="p"
            :cover="populated(p.coverImage)"
            :sizes="'sm:50vw lg:33vw 100vw'"
            class="h-[320px]"
          />
        </div>
      </template>

      <!-- Пустая категория (спека §05.50) -->
      <div
        v-else
        class="mt-6 rounded-[var(--radius-lg)] border border-dashed border-[var(--color-line)] px-6 py-12 text-center"
      >
        <p class="text-[var(--color-ink-muted)]">В этой категории пока нет проектов.</p>
        <button type="button" class="link-arrow mt-3 text-sm" @click="activeSlug = null">
          Показать все проекты
        </button>
      </div>
    </div>
  </section>
</template>
