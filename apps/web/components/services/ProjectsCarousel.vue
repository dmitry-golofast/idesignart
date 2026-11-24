<script setup lang="ts">
import type { Project } from '#shared/types/payload'

/**
 * ProjectsCarousel — «Примеры работ» на странице услуги: горизонтальная
 * карусель карточек проектов на готовом UCarousel из UI kit.
 *
 * Это отдельный компактный список, а не полноэкранный блок главной
 * (BlocksPortfolioMasonry): на посадочной странице услуги примеры
 * дополняют текст и не должны перебивать его по масштабу. Карточка —
 * та же, что в портфолио (BlocksPortfolioProjectCard). На узких экранах
 * листается свайпом, от sm — стрелками.
 */
defineProps<{
  projects: Project[]
  title?: string
}>()
</script>

<template>
  <section class="section border-t border-[var(--color-line)]">
    <div class="container-app">
      <div class="flex flex-wrap items-end justify-between gap-x-8 gap-y-3">
        <h2 class="text-[1.75rem] leading-[1.1] lg:text-[2.5rem]">
          {{ title || 'Примеры работ' }}
        </h2>
        <!-- Стрелку добавляет сам .link-arrow (::after) -->
        <NuxtLink to="/portfolio" class="link-arrow pb-1 text-base">
          Все проекты
        </NuxtLink>
      </div>

      <!-- Стрелки карусели UI kit выносит за её края на 48px (sm:-start-12 /
           sm:-end-12) — на ту же величину отступаем от краёв контейнера,
           иначе они вылезут за экран. -->
      <div class="mt-8 sm:px-12">
        <UCarousel
          v-slot="{ item }"
          :items="projects"
          align="start"
          :arrows="projects.length > 1"
          :ui="{
            item: 'basis-[84%] sm:basis-[58%] lg:basis-[42%] xl:basis-1/3',
            arrows: 'hidden sm:flex',
          }"
        >
          <BlocksPortfolioProjectCard
            :project="item"
            :cover="populated(item.coverImage)"
            sizes="sm:50vw lg:40vw xl:33vw 100vw"
            class="h-[280px] sm:h-[300px]"
          />
        </UCarousel>
      </div>
    </div>
  </section>
</template>
