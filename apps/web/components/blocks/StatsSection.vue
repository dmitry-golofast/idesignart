<script setup lang="ts">
/**
 * StatsSection — полоса статистики (цифры).
 * Editorial-стиль: жирные числа Inter, тонкая линия над каждой ячейкой.
 * Принимает items из CMS или через props.
 */
defineProps<{
  items?: { value: string; label: string }[]
  eyebrow?: string
  title?: string
}>()
</script>

<template>
  <section class="border-y border-[var(--color-line)] bg-[var(--color-surface)]">
    <div class="container-app section-sm">
      <div v-if="eyebrow || title" class="mb-10 max-w-2xl">
        <p v-if="eyebrow" class="eyebrow">{{ eyebrow }}</p>
        <h2 v-if="title" class="section-title mt-3">{{ title }}</h2>
      </div>
      <div class="grid grid-cols-2 gap-x-6 gap-y-10 lg:grid-cols-4">
        <div v-for="(stat, i) in items" :key="i" class="border-t-2 border-[var(--color-ink)] pt-5">
          <p class="text-4xl font-extrabold tracking-[-0.02em] text-[var(--color-ink)] sm:text-5xl">
            {{ stat.value }}
          </p>
          <p class="mt-2 flex items-center gap-2 text-sm text-[var(--color-ink-muted)]">
            <span class="inline-block h-2 w-2 shrink-0 bg-[var(--color-accent)]" aria-hidden="true" />
            {{ stat.label }}
          </p>
        </div>
      </div>
    </div>
  </section>
</template>
