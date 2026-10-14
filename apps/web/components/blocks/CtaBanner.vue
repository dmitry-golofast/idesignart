<script setup lang="ts">
/**
 * CtaBanner — призыв к действию (редизайн v3, язык ayocin).
 * Тёмная эспрессо-панель с крупным заголовком, gold-чипом
 * и светлой пилюлей со стрелкой-орбом.
 */
const props = defineProps<{
  title?: string
  description?: string
  primaryCta?: { label?: string; href?: string }
  variant?: 'dark' | 'accent'
}>()

// Оба варианта — тёмная эспрессо-панель; accent добавляет gold-чип
const isAccent = computed(() => props?.variant === 'accent')
</script>

<template>
  <section class="section section-full">
    <div class="container-app">
      <div
        class="rounded-[var(--radius-xl)] bg-[var(--color-espresso)] px-8 py-14 text-[#f6f1e7] sm:px-12 lg:px-20 lg:py-24"
        data-reveal
      >
        <span v-if="isAccent" class="chip-outline !border-[#e0b73f] !text-[#e0b73f]" data-reveal="fade">
          Свободны для новых проектов
        </span>

        <h2
          class="max-w-3xl font-display text-[clamp(2.25rem,5vw,4.5rem)] leading-[1.04] font-extrabold tracking-[-0.03em] text-[#f6f1e7]"
          data-reveal-line
        >
          <span class="reveal-line" style="--reveal-delay: 80ms">
            <span class="reveal-line-inner">{{ title }}</span>
          </span>
        </h2>

        <p
          v-if="description"
          class="mt-5 max-w-xl text-[17px] leading-relaxed text-[#f6f1e7]/65"
          data-reveal="fade"
          style="--reveal-delay: 200ms"
        >
          {{ description }}
        </p>

        <div v-if="primaryCta?.href" data-reveal style="--reveal-delay: 320ms">
          <NuxtLink :to="primaryCta.href" class="btn-pill btn-pill-light mt-10">
            {{ primaryCta.label || 'Оставить заявку' }}
            <span class="btn-pill-orb" aria-hidden="true">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M7 17 17 7" />
                <path d="M8 7h9v9" />
              </svg>
            </span>
          </NuxtLink>
        </div>
      </div>
    </div>
  </section>
</template>
