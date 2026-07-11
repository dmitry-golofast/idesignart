<script setup lang="ts">
import { computed } from 'vue'

/**
 * Главная страница — рендерит ТОЛЬКО блоки из CMS (Payload).
 *
 * Вся структура и контент управляются через админку:
 * http://localhost:3001/admin → Pages → home → «Блоки страницы»
 *
 * Если страница не опубликована или без блоков — пустая страница.
 */

const { data: pageData } = await usePage('home')

const page = computed(() => pageData.value?.docs?.[0])
const sections = computed(() => page.value?.sections || [])

// SEO из CMS
useSeo({
  title: page.value?.seo?.title || page.value?.title || 'idesignart — дизайн интерьера и 3D-визуализация',
  description: page.value?.seo?.description,
  keywords: page.value?.seo?.keywords,
})
</script>

<template>
  <div>
    <PageSections :sections="sections" />
  </div>
</template>
