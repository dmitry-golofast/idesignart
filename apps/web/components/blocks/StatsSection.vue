<script setup lang="ts">
import { computed } from 'vue'
import type { Media } from '#shared/types/payload'

/**
 * StatsSection — блок «Цифры» (редизайн v3, язык ayocin).
 *
 * Editorial-колонки вместо карточек-боксов: hairline-верхняя линия,
 * опциональное фото (поле «Фоновая картинка» в CMS), иконка-кольцо,
 * крупная цифра-гротеск, подпись и пояснение. Появление — stagger.
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
  <section class="section section-full bg-[var(--color-canvas)]">
    <div class="container-app">
      <ul
        class="grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-4"
        aria-label="Студия в цифрах"
      >
        <li
          v-for="(stat, i) in cards"
          :key="stat.value"
          class="flex flex-col border-t border-[var(--color-ink)] pt-5"
          data-reveal
          :style="{ '--reveal-delay': `${i * 110}ms` }"
        >
          <!-- Фото-скетч из CMS: мягкая карточка над цифрой -->
          <div
            v-if="imageUrl(stat.image)"
            class="mb-5 overflow-hidden rounded-[14px]"
            aria-hidden="true"
          >
            <NuxtImg
              :src="imageUrl(stat.image)!"
              alt=""
              sizes="sm:50vw lg:25vw 100vw"
              format="webp,avif"
              class="aspect-[4/3] w-full object-cover"
            />
          </div>

          <span class="icon-ring mb-5" aria-hidden="true">
            <UIcon :name="stat.icon" class="h-4.5 w-4.5" />
          </span>

          <p class="font-display text-[clamp(2.75rem,3.6vw,3.75rem)] leading-none font-extrabold tracking-[-0.03em] text-[var(--color-ink)]">
            {{ stat.value }}
          </p>
          <p class="mt-3 text-[17px] leading-snug font-semibold text-[var(--color-ink)] sm:text-lg">
            {{ stat.label }}
          </p>
          <p v-if="stat.description" class="mt-1.5 text-sm leading-snug text-[var(--color-ink-muted)]">
            {{ stat.description }}
          </p>
        </li>
      </ul>
    </div>
  </section>
</template>
