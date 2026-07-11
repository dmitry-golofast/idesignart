<script setup lang="ts">
/**
 * ContentSection — произвольный текстовый блок (rich text).
 * Для статей, описаний, встроенного контента на странице.
 */
defineProps<{
  eyebrow?: string
  title?: string
  body?: any
  layout?: 'narrow' | 'wide'
}>()
</script>

<template>
  <section class="section">
    <div class="container-app">
      <div :class="layout === 'wide' ? 'max-w-5xl' : 'max-w-3xl'" class="mx-auto">
        <p v-if="eyebrow" class="eyebrow">{{ eyebrow }}</p>
        <h2 v-if="title" class="mt-3 mb-6 font-display text-[var(--text-h2)]">{{ title }}</h2>
        <RichTextRenderer v-if="body" :content="body" />
      </div>
    </div>
  </section>
</template>
