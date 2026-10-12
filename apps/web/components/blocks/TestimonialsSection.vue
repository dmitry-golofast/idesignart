<script setup lang="ts">
/**
 * TestimonialsSection — блок отзывов.
 * Единый язык: белые карточки с тонкой границей, жирные имена, лайм-деталь.
 * Принимает items из CMS или через props.
 */
defineProps<{
  eyebrow?: string
  title?: string
  items?: { quote: string; author: string; role?: string }[]
}>()
</script>

<template>
  <section v-if="items?.length" class="section">
    <div class="container-app">
      <div class="mb-10 max-w-2xl">
        <p v-if="eyebrow" class="eyebrow">{{ eyebrow }}</p>
        <h2 v-if="title" class="section-title mt-3">{{ title }}</h2>
      </div>
      <div class="grid gap-4 md:grid-cols-3">
        <figure
          v-for="(t, i) in items"
          :key="i"
          class="flex flex-col rounded-xl border border-[var(--color-line)] bg-[var(--color-surface)] p-7"
        >
          <div class="mb-5 flex h-9 w-9 items-center justify-center rounded-full border border-[var(--color-lime)] bg-[var(--color-lime)]/10">
            <UIcon name="i-lucide-quote" class="h-4 w-4 text-[var(--color-ink)]" aria-hidden="true" />
          </div>
          <blockquote class="flex-1 leading-relaxed text-[var(--color-ink)]">
            {{ t.quote }}
          </blockquote>
          <figcaption class="mt-6 border-t border-[var(--color-line)] pt-4">
            <p class="font-bold text-[var(--color-ink)]">{{ t.author }}</p>
            <p v-if="t.role" class="mt-0.5 text-sm text-[var(--color-ink-muted)]">{{ t.role }}</p>
          </figcaption>
        </figure>
      </div>
    </div>
  </section>
</template>
