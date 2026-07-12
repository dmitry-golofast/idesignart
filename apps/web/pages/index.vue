<script setup lang="ts">
import { computed } from 'vue'

/**
 * Главная страница — рендерит блоки из CMS (Payload).
 *
 * Вся структура и контент управляются через админку:
 * http://localhost:3001/admin → Pages → home → «Блоки страницы»
 *
 * key на <PageSections> форсирует перерисовку при возврате на страницу.
 */

const { data: pageData } = await usePage('home')

const page = computed(() => pageData.value?.docs?.[0])
const sections = computed(() => page.value?.sections || [])

// Уникальный key — меняется при изменении данных, форсирует перерисовку
const renderKey = computed(() => {
  const s = sections.value
  return `home-${s.length}-${s.map((x: any) => x.blockType).join(',')}`
})

// SEO из CMS
useSeo({
  title: page.value?.seo?.title || page.value?.title || 'idesignart — дизайн интерьера и 3D-визуализация',
  description: page.value?.seo?.description,
  keywords: page.value?.seo?.keywords,
})
</script>

<template>
  <div>
    <PageSections v-if="sections.length" :key="renderKey" :sections="sections" />
  </div>
</template>
