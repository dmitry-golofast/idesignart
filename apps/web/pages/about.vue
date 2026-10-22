<script setup lang="ts">
import { computed } from 'vue'

/**
 * «О студии» — контент из CMS (Pages → slug=about, блок «О студии — шапка»):
 * текст слева, фото справа, под фото — цитата основателя. Пока страницы
 * в CMS нет — дефолты компонента AboutHero.
 */
const { data: pageData } = await usePage('about')

const page = computed(() => pageData.value?.docs?.[0])
const sections = computed(() => page.value?.sections || [])

useSeo({
  title: page.value?.meta?.title || page.value?.title || 'О студии — idesignart',
  description: page.value?.meta?.description,
  noindex: page.value?.meta?.noindex ?? false,
})
</script>

<template>
  <div>
    <PageSections v-if="sections.length" :sections="sections" />
    <BlocksAboutHero v-else />
  </div>
</template>
