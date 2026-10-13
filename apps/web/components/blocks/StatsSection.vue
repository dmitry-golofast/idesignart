<script setup lang="ts">
import { computed } from 'vue'
import type { Media } from '#shared/types/payload'

/**
 * StatsSection — блок «Цифры» (статистика) v2.
 *
 * Только карточки, без шапки секции: иконка с лаймовым акцентом,
 * крупное значение, подпись, черта и пояснение. Скетч-картинка
 * (поле «Фоновая картинка» в CMS) лежит полупрозрачно фоном,
 * текстовая зона снизу защищена белым градиентом.
 *
 * Всё управляется из CMS (блок «Цифры» → «Показатели»);
 * DEFAULT_ITEMS — демо-фолбэк, если блок ещё не заполнен.
 */
interface StatItem {
  value: string
  label: string
  description?: string | null
  icon?: string | null
  image?: Media | number | null
}

const props = defineProps<{ items?: StatItem[] | null }>()

const payloadBase = useRuntimeConfig().public.payloadApiUrl as string

type StatIconKey = 'layers' | 'house' | 'leaf' | 'compass' | 'heart' | 'trending-up'

const statIcons: Record<StatIconKey, string> = {
  layers: 'i-lucide-layers',
  house: 'i-lucide-house',
  leaf: 'i-lucide-leaf',
  compass: 'i-lucide-compass',
  heart: 'i-lucide-heart',
  'trending-up': 'i-lucide-trending-up',
}

function iconFor(key: string | null | undefined): string {
  return (key && statIcons[key as StatIconKey]) || statIcons.layers
}

const DEFAULT_ITEMS: StatItem[] = [
  { icon: 'layers', value: '120+', label: 'реализованных проектов', description: 'квартиры, дома, коммерческие пространства' },
  { icon: 'compass', value: '8 лет', label: 'опыта в дизайне интерьеров', description: 'от концепции до реализации' },
  { icon: 'heart', value: '98%', label: 'клиентов рекомендуют нас', description: 'по итогам завершённых проектов' },
  { icon: 'trending-up', value: '×2', label: 'быстрая продажа объекта', description: 'с визуализацией и хоумстейджингом' },
]

interface StatCard {
  value: string
  label: string
  description: string
  icon: string
  image: Media | null
}

function toCard(s: StatItem): StatCard {
  return {
    value: s.value,
    label: s.label,
    description: s.description ?? '',
    icon: iconFor(s.icon),
    image: populated(s.image),
  }
}

const cards = computed<StatCard[]>(() => {
  const fromCms = (props.items ?? [])
    .filter((s): s is StatItem => Boolean(s?.value && s?.label))
    .map(toCard)
  return fromCms.length ? fromCms : DEFAULT_ITEMS.map(toCard)
})

function imageUrl(image: Media | null): string | null {
  if (!image?.url) return null
  return image.url.startsWith('http') ? image.url : `${payloadBase}${image.url}`
}
</script>

<template>
  <section class="bg-white">
    <div class="container-app section-sm">
      <ul
        class="grid grid-cols-1 gap-4 sm:grid-cols-2 sm:gap-5 lg:grid-cols-4 lg:gap-6"
        aria-label="Студия в цифрах"
      >
        <li
          v-for="stat in cards"
          :key="stat.value"
          class="group relative overflow-hidden rounded-[var(--radius-lg)] border border-[var(--color-line)] bg-[var(--color-surface)] shadow-[var(--shadow-xs)] transition-[box-shadow,transform] duration-300 ease-[var(--ease-premium)] hover:-translate-y-0.5 hover:shadow-[var(--shadow-card)]"
        >
          <!-- Фоновая картинка: скетч/фото, приглушена и увеличивается на hover -->
          <div v-if="imageUrl(stat.image)" class="absolute inset-0" aria-hidden="true">
            <NuxtImg
              :src="imageUrl(stat.image)!"
              alt=""
              sizes="sm:50vw lg:25vw 100vw"
              format="webp,avif"
              class="h-full w-full object-cover transition-transform duration-500 ease-premium group-hover:scale-[1.04]"
            />
          </div>
          <!-- Без картинки — мягкое лаймовое пятно, чтобы карточка не была пустой -->
          <div
            v-else
            class="absolute -top-20 -right-14 h-56 w-56 rounded-full bg-[var(--color-accent-soft)] blur-2xl"
            aria-hidden="true"
          />

          <!-- Белый градиент снизу: текстовая зона остаётся читаемой на любой картинке -->
          <div
            class="absolute inset-0 bg-linear-to-t from-surface from-10% via-surface/75 via-25% to-transparent"
            aria-hidden="true"
          />

          <div class="relative flex h-full flex-col p-6 lg:p-7">
            <p class="mt-10 font-display text-[clamp(2.5rem,3.4vw,3.5rem)] leading-none font-extrabold tracking-[-0.03em] text-[var(--color-ink)]">
              {{ stat.value }}
            </p>
            <p class="mt-3 text-[17px] leading-snug font-semibold text-[var(--color-ink)] sm:text-lg">
              {{ stat.label }}
            </p>
          </div>
        </li>
      </ul>
    </div>
  </section>
</template>
