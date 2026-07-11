<script setup lang="ts">
/**
 * /services — концентратор услуг.
 * Ссылается на отдельные посадочные /services/[slug].
 */
useSeo({
  title: 'Услуги — дизайн интерьера и 3D-визуализация',
  description: 'Дизайн квартиры, дома, офиса. 3D-визуализация интерьера. Планировочные решения и авторский надзор.',
})
</script>

<template>
  <div>
    <BlocksServicesGrid
      eyebrow="Услуги"
      title="Что мы делаем"
    />
  </div>
</template>
