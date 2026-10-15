<script setup lang="ts">
/**
 * /services — концентратор услуг.
 * Ссылается на отдельные посадочные /services/[slug].
 *
 * Фон и заголовок блока редактируются в одном месте — в CMS-блоке
 * «Сетка услуг» на главной; здесь берём из него bgImage.
 */
useSeo({
  title: 'Услуги — дизайн интерьера и 3D-визуализация',
  description: 'Дизайн квартиры, дома, офиса. 3D-визуализация интерьера. Планировочные решения и авторский надзор.',
})

const { data: homeData } = await usePage('home')
const servicesBlock = computed(() =>
  (homeData.value?.docs?.[0]?.sections ?? []).find((s) => s.blockType === 'services-grid'),
)
</script>

<template>
  <div>
    <BlocksServicesGrid title="Что мы делаем" :bg-image="servicesBlock?.bgImage" />
  </div>
</template>
