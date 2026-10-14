<script setup lang="ts">
/**
 * ContentSection — произвольный текстовый блок (rich text).
 * Для статей, описаний, встроенного контента на странице.
 * Редизайн v3: editorial-шапка при наличии eyebrow.
 */
defineProps<{
  eyebrow?: string
  title?: string
  body?: any
  layout?: 'narrow' | 'wide'
}>()
</script>

<template>
  <section class="section section-full">
    <div class="container-app">
      <div :class="layout === 'wide' ? 'max-w-5xl' : 'max-w-3xl'" class="mx-auto">
        <p v-if="eyebrow" class="eyebrow" data-reveal="fade">{{ eyebrow }}</p>
        <h2 v-if="title" class="section-title mb-6 mt-3" data-reveal>{{ title }}</h2>
        <div v-if="body" data-reveal="fade" style="--reveal-delay: 100ms">
          <RichTextRenderer :content="body" />
        </div>
      </div>
    </div>
  </section>
</template>
