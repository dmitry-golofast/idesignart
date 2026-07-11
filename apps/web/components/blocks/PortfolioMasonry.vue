<script setup lang="ts">
import { computed } from 'vue'

/**
 * PortfolioMasonry — асимметричная сетка избранных проектов.
 * Референс: Norm Architects (крупные изображения, воздух, hover-превью).
 *
 * На главной показывает featured; на /portfolio — все с фильтрами.
 */
interface Project {
  id: string
  title: string
  slug: string
  excerpt?: string
  coverImage?: { url?: string; alt?: string } | null
  meta?: {
    area?: number
    propertyType?: string
    style?: string
    location?: string
  }
}

const props = defineProps<{
  projects?: Project[]
  title?: string
  eyebrow?: string
  limit?: number
}>()

const { data } = useProjects({ featured: !props.projects?.length, limit: props.limit || 6 })
const projects = computed(() =>
  props.projects?.length ? props.projects : (data.value?.docs || []),
)

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

const propertyLabels: Record<string, string> = {
  apartment: 'Квартира',
  house: 'Дом',
  office: 'Офис',
  hospitality: 'HoReCa',
  retail: 'Retail',
}

const styleLabels: Record<string, string> = {
  modern: 'Современный',
  minimal: 'Минимализм',
  scandi: 'Скандинавский',
  loft: 'Лофт',
  classic: 'Классика',
  neoclassic: 'Неоклассика',
  japandi: 'Джапанди',
}
</script>

<template>
  <section class="section">
    <div class="container-app">
      <div class="mb-12 flex flex-wrap items-end justify-between gap-6">
        <div class="max-w-2xl">
          <p class="eyebrow">{{ eyebrow || 'Избранные проекты' }}</p>
          <h2 class="mt-3 font-display text-[var(--text-h2)]">
            {{ title || 'Кейсы, которыми мы гордимся' }}
          </h2>
        </div>
        <UButton to="/portfolio" variant="ghost" color="neutral" trailing-icon="i-lucide-arrow-right">
          Все проекты
        </UButton>
      </div>

      <!-- Masonry-сетка (CSS columns для простоты) -->
      <div class="columns-1 gap-6 sm:columns-2 lg:columns-3 [&>*]:mb-6 [&>*]:break-inside-avoid">
        <NuxtLink
          v-for="project in projects"
          :key="project.id"
          :to="`/portfolio/${project.slug}`"
          class="group relative block overflow-hidden rounded-[var(--radius-lg)] bg-[var(--color-surface-alt)]"
        >
          <!-- Обложка -->
          <NuxtImg
            v-if="project.coverImage?.url"
            :src="project.coverImage.url.startsWith('http') ? project.coverImage.url : `${payloadBase}${project.coverImage.url}`"
            :alt="project.coverImage.alt || project.title"
            class="w-full object-cover transition-transform duration-[var(--duration-slow)] ease-[var(--ease-premium)] group-hover:scale-105"
            sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
            format="webp,avif"
          />

          <!-- Оверлей при hover -->
          <div class="absolute inset-0 flex flex-col justify-end bg-gradient-to-t from-black/80 via-black/20 to-transparent p-6 opacity-0 transition-opacity duration-[var(--duration-base)] group-hover:opacity-100">
            <div class="flex flex-wrap gap-2">
              <span v-if="project.meta?.propertyType" class="rounded-[var(--radius-pill)] bg-[var(--color-canvas)]/20 px-3 py-1 text-xs text-[var(--color-canvas)] backdrop-blur-sm">
                {{ propertyLabels[project.meta.propertyType] || project.meta.propertyType }}
              </span>
              <span v-if="project.meta?.style" class="rounded-[var(--radius-pill)] bg-[var(--color-canvas)]/20 px-3 py-1 text-xs text-[var(--color-canvas)] backdrop-blur-sm">
                {{ styleLabels[project.meta.style] || project.meta.style }}
              </span>
              <span v-if="project.meta?.area" class="rounded-[var(--radius-pill)] bg-[var(--color-canvas)]/20 px-3 py-1 text-xs text-[var(--color-canvas)] backdrop-blur-sm">
                {{ project.meta.area }} м²
              </span>
            </div>
            <h3 class="mt-3 font-display text-xl text-[var(--color-canvas)]">
              {{ project.title }}
            </h3>
          </div>

          <!-- Видимый заголовок (mobile / без hover) -->
          <div class="p-5">
            <h3 class="font-display text-lg text-[var(--color-ink)]">
              {{ project.title }}
            </h3>
          </div>
        </NuxtLink>
      </div>
    </div>
  </section>
</template>
