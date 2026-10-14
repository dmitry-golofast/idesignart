<script setup lang="ts">
/**
 * TestimonialsSection — блок отзывов (редизайн v3, язык ayocin).
 * Editorial-колонки с hairline-верхом вместо боксов: крупная цитата,
 * буква-индекс в кольце, имя и роль. Появление — stagger.
 * Принимает items из CMS или через props.
 */
const props = defineProps<{
  eyebrow?: string
  title?: string
  items?: { quote: string; author: string; role?: string }[]
  /** Номер главы — присваивается по порядку блоков на странице (PageSections) */
  num?: number
}>()

const secNum = computed(() => String(props.num ?? 1).padStart(2, '0'))

/** Буквенные индексы A/B/C… — editorial-нумерация как у ayocin */
const LETTERS = ['A', 'B', 'C', 'D', 'E', 'F']

const letter = (i: number) => LETTERS[i] ?? String(i + 1)
</script>

<template>
  <section v-if="items?.length" class="section section-full">
    <div class="container-app">
      <!-- Editorial-шапка -->
      <div class="sec-head" data-reveal>
        <span class="sec-num" aria-hidden="true">{{ secNum }}</span>
        <h2 v-if="title" class="sec-title">{{ title }}</h2>
        <h2 v-else class="sec-title">{{ eyebrow || 'Отзывы' }}</h2>
      </div>

      <div class="mt-10 grid gap-x-8 gap-y-12 md:grid-cols-3">
        <figure
          v-for="(t, i) in items"
          :key="i"
          class="flex flex-col border-t border-[var(--color-line)] pt-6"
          data-reveal
          :style="{ '--reveal-delay': `${i * 120}ms` }"
        >
          <span class="icon-ring mb-6 h-11 w-11 text-sm font-medium" aria-hidden="true">
            {{ letter(i) }}
          </span>
          <blockquote class="flex-1 text-[17px] leading-relaxed tracking-[-0.01em] text-[var(--color-ink)]">
            {{ t.quote }}
          </blockquote>
          <figcaption class="mt-8">
            <p class="font-bold text-[var(--color-ink)]">{{ t.author }}</p>
            <p v-if="t.role" class="mt-0.5 text-sm text-[var(--color-ink-muted)]">{{ t.role }}</p>
          </figcaption>
        </figure>
      </div>
    </div>
  </section>
</template>
