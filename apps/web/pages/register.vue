<script setup lang="ts">
import { computed } from 'vue'

/**
 * Регистрация — страница-заглушка. Контент берётся из CMS
 * (Pages → slug=register), пока это текстовый блок с пометкой.
 */
const { data: pageData } = await usePage('register')

const page = computed(() => pageData.value?.docs?.[0])
const sections = computed(() => page.value?.sections || [])

useSeo({
  title: page.value?.seo?.title || page.value?.title || 'Регистрация — idesignart',
  description: page.value?.seo?.description,
  noindex: true,
})
</script>

<template>
  <div>
    <PageSections v-if="sections.length" :sections="sections" />
    <section v-else class="section">
      <div class="container-app">
        <h1 class="font-display text-[var(--text-h1)]">Регистрация</h1>
        <p class="mt-4 text-[var(--color-ink-muted)]">Форма регистрации появится здесь.</p>
      </div>
    </section>
  </div>
</template>
