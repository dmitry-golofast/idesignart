<script setup lang="ts">
useSeo({
  title: 'Как мы работаем — процесс дизайна интерьера',
  description: 'Прозрачный процесс от брифинга до авторского надзора. 4 этапа, фиксированные сроки и смета.',
})
</script>

<template>
  <div>
    <section class="bg-[var(--color-surface)] pt-32">
      <div class="container-app pb-8">
        <p class="eyebrow">Процесс</p>
        <h1 class="mt-3 max-w-3xl font-display text-[var(--text-h1)]">
          Как мы работаем
        </h1>
        <p class="mt-4 max-w-2xl text-lg text-[var(--color-ink-muted)]">
          Прозрачный процесс от идеи до переезда. Вы всегда знаете, на каком этапе проект.
        </p>
      </div>
    </section>

    <BlocksProcessSteps />
    <BlocksPricingCalculator />
    <BlocksContactForm
      eyebrow="Обсудить проект"
      title="Расскажите о вашей задаче"
      source="process-page"
    />
  </div>
</template>
