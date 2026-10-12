<script setup lang="ts">
/**
 * CtaBanner — призыв к действию (баннер).
 * Вариант dark (графит + лаймовая кнопка) или accent (лаймовая плашка).
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
        class="rounded-[var(--radius-lg)] p-10 lg:p-16"
        :class="isAccent
          ? 'bg-[var(--color-accent)] text-[var(--color-accent-contrast)]'
          : 'bg-[var(--color-ink)] text-[var(--color-canvas)]'"
      >
        <h2 class="section-title max-w-2xl" :class="isAccent ? 'text-[var(--color-accent-contrast)]' : 'text-[var(--color-canvas)]'">
          {{ title }}
        </h2>
        <p
          v-if="description"
          class="mt-4 max-w-xl"
          :class="isAccent ? 'text-[var(--color-accent-contrast)]/70' : 'text-[var(--color-canvas)]/60'"
        >
          {{ description }}
        </p>
        <template v-if="primaryCta?.href">
          <!-- На тёмном — лаймовая кнопка, на лаймовом — тёмная -->
          <NuxtLink
            :to="primaryCta.href"
            class="btn-lime mt-8"
            :class="isAccent ? 'bg-[var(--color-ink)] text-[var(--color-canvas)] hover:bg-[var(--color-ink)]/85' : ''"
          >
            {{ primaryCta.label || 'Оставить заявку' }}
            <UIcon name="i-lucide-arrow-right" class="h-4 w-4" aria-hidden="true" />
          </NuxtLink>
        </template>
      </div>
    </div>
  </section>
</template>
