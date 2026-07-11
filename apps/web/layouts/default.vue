<script setup lang="ts">
// Layout по умолчанию: Header + page + Footer
// Settings тянем один раз — нужны в шапке и подвале
const { data: settings } = useSettings()
</script>

<template>
  <div class="flex min-h-screen flex-col">
    <AppHeader :settings="settings" />
    <main class="flex-1">
      <slot />
    </main>
    <AppFooter :settings="settings" />
  </div>
</template>
