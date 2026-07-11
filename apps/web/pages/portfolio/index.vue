<script setup lang="ts">
/**
 * /portfolio — список всех проектов.
 */
useSeo({
  title: 'Портфолио — проекты студии дизайна интерьера',
  description: 'Кейсы дизайн-проектов квартир, домов, офисов и общественных пространств. 3D-визуализация и реализованные интерьеры.',
})
</script>

<template>
  <div>
    <BlocksPortfolioMasonry
      eyebrow="Портфолио"
      title="Все проекты"
      :limit="24"
    />
  </div>
</template>
