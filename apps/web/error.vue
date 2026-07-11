<script setup lang="ts">
// clearError, useSeo — Nuxt auto-imports
const props = defineProps<{ error: { statusCode: number; message?: string } }>()

useSeo({
  title: props.error.statusCode === 404 ? 'Страница не найдена' : 'Ошибка',
  noindex: true,
})

function handleClear() {
  clearError({ redirect: '/' })
}
</script>

<template>
  <div class="flex min-h-screen flex-col items-center justify-center bg-[var(--color-canvas)] px-6 text-center">
    <p class="font-display text-[clamp(5rem,15vw,12rem)] leading-none text-[var(--color-accent)]">
      {{ error.statusCode }}
    </p>
    <h1 class="mt-4 font-display text-[var(--text-h2)]">
      {{ error.statusCode === 404 ? 'Страница не найдена' : 'Что-то пошло не так' }}
    </h1>
    <p class="mt-3 max-w-md text-[var(--color-ink-muted)]">
      {{ error.statusCode === 404
        ? 'Возможно, страница была перемещена или удалена.'
        : 'Произошла ошибка. Попробуйте обновить страницу.' }}
    </p>
    <UButton size="lg" color="primary" class="mt-8" @click="handleClear">
      На главную
    </UButton>
  </div>
</template>
