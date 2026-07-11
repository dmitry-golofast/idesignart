<script setup lang="ts">
/**
 * TestimonialsSection — блок отзывов.
 * Принимает items из CMS или через props.
 */
defineProps<{
  eyebrow?: string
  title?: string
  items?: { quote: string; author: string; role?: string }[]
}>()
</script>

<template>
  <section v-if="items?.length" class="section bg-[var(--color-surface)]">
    <div class="container-app">
      <div class="mb-12 max-w-2xl">
        <p v-if="eyebrow" class="eyebrow">{{ eyebrow }}</p>
        <h2 v-if="title" class="mt-3 font-display text-[var(--text-h2)]">{{ title }}</h2>
      </div>
      <div class="grid gap-6 md:grid-cols-3">
        <figure
          v-for="(t, i) in items"
          :key="i"
          class="flex flex-col rounded-[var(--radius-lg)] bg-[var(--color-canvas)] p-8 shadow-[var(--shadow-card)]"
        >
          <UIcon name="i-lucide-quote" class="mb-4 h-8 w-8 text-[var(--color-accent-soft)]" />
          <blockquote class="flex-1 text-[var(--color-ink-muted)]">«{{ t.quote }}»</blockquote>
          <figcaption class="mt-6">
            <p class="font-medium text-[var(--color-ink)]">{{ t.author }}</p>
            <p v-if="t.role" class="text-sm text-[var(--color-ink-subtle)]">{{ t.role }}</p>
          </figcaption>
        </figure>
      </div>
    </div>
  </section>
</template>
