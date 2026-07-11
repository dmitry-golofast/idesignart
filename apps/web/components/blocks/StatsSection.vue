<script setup lang="ts">
/**
 * StatsSection — полоса статистики (цифры).
 * Принимает items из CMS или через props.
 */
defineProps<{
  items?: { value: string; label: string }[]
  eyebrow?: string
  title?: string
}>()
</script>

<template>
  <section class="border-b border-[var(--color-line)] bg-[var(--color-surface)]">
    <div class="container-app section-sm">
      <div v-if="title" class="mb-8 max-w-2xl">
        <p v-if="eyebrow" class="eyebrow">{{ eyebrow }}</p>
        <h2 class="mt-2 font-display text-[var(--text-h2)]">{{ title }}</h2>
      </div>
      <div class="grid grid-cols-2 gap-8 lg:grid-cols-4">
        <div v-for="(stat, i) in items" :key="i" class="text-center">
          <p class="font-display text-[var(--text-h2)] text-[var(--color-accent)]">{{ stat.value }}</p>
          <p class="mt-1 text-sm text-[var(--color-ink-muted)]">{{ stat.label }}</p>
        </div>
      </div>
    </div>
  </section>
</template>
