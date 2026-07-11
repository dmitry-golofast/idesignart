<script setup lang="ts">
/**
 * CtaBanner — призыв к действию (баннер).
 * Вариант dark (графит) или accent (терракота).
 */
const props = defineProps<{
  title?: string
  description?: string
  primaryCta?: { label?: string; href?: string }
  variant?: 'dark' | 'accent'
}>()

const isAccent = computed(() => props?.variant === 'accent')
</script>

<template>
  <section class="section">
    <div class="container-app">
      <div
        class="rounded-[var(--radius-xl)] p-12 text-center lg:p-16"
        :class="isAccent
          ? 'bg-[var(--color-accent)] text-[var(--color-accent-contrast)]'
          : 'bg-[var(--color-ink)] text-[var(--color-canvas)]'"
      >
        <h2 class="font-display text-[var(--text-h2)]">{{ title }}</h2>
        <p
          v-if="description"
          class="mx-auto mt-3 max-w-md"
          :class="isAccent ? 'text-[var(--color-accent-contrast)]/80' : 'text-[var(--color-canvas)]/70'"
        >
          {{ description }}
        </p>
        <UButton
          v-if="primaryCta?.href"
          :to="primaryCta.href"
          size="lg"
          :color="isAccent ? 'neutral' : 'primary'"
          :variant="isAccent ? 'solid' : 'solid'"
          class="mt-8"
        >
          {{ primaryCta.label || 'Оставить заявку' }}
        </UButton>
      </div>
    </div>
  </section>
</template>
