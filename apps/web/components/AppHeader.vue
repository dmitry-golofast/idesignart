<script setup lang="ts">
import { ref, computed } from 'vue'

interface SettingsData {
  brand?: { name?: string; tagline?: string }
  contacts?: { phone?: string; whatsapp?: string; telegram?: string }
}

const props = defineProps<{ settings?: { value?: SettingsData } }>()

const open = ref(false)
const config = useRuntimeConfig()

const brand = computed(() => props.settings?.value?.brand?.name || 'idesignart')
const phone = computed(() => props.settings?.value?.contacts?.phone || config.public.phone)

const nav = [
  { label: 'Услуги', to: '/services' },
  { label: 'Портфолио', to: '/portfolio' },
  { label: 'Процесс', to: '/process' },
  { label: 'О студии', to: '/about' },
  { label: 'Блог', to: '/blog' },
  { label: 'Контакты', to: '/contacts' },
]

// Закрытие меню при клике на ссылку
watch(() => useRoute().fullPath, () => { open.value = false })
</script>

<template>
  <header
    class="sticky top-0 z-[var(--z-header)] border-b border-[var(--color-line)]/60 bg-[var(--color-canvas)]/80 backdrop-blur-lg"
  >
    <div class="container-app flex h-16 items-center justify-between gap-4 lg:h-20">
      <!-- Лого -->
      <NuxtLink to="/" class="font-display text-xl font-medium tracking-tight text-[var(--color-ink)] lg:text-2xl">
        {{ brand }}
      </NuxtLink>

      <!-- Десктоп-навигация -->
      <nav class="hidden items-center gap-8 lg:flex">
        <NuxtLink
          v-for="item in nav"
          :key="item.to"
          :to="item.to"
          class="text-sm text-[var(--color-ink-muted)] transition-colors duration-[var(--duration-base)] hover:text-[var(--color-ink)]"
          active-class="text-[var(--color-ink)]"
        >
          {{ item.label }}
        </NuxtLink>
      </nav>

      <!-- CTA + бургер -->
      <div class="flex items-center gap-3">
        <UButton
          v-if="phone"
          :to="`tel:${phone}`"
          variant="ghost"
          color="neutral"
          class="hidden text-sm md:inline-flex"
        >
          {{ phone }}
        </UButton>
        <UButton to="/contacts" color="primary" size="md" class="hidden sm:inline-flex">
          Обсудить проект
        </UButton>

        <!-- Бургер (mobile) -->
        <UButton
          :icon="open ? 'i-lucide-x' : 'i-lucide-menu'"
          color="neutral"
          variant="ghost"
          class="lg:hidden"
          aria-label="Меню"
          @click="open = !open"
        />
      </div>
    </div>

    <!-- Мобильное меню -->
    <Transition
      enter-active-class="transition duration-[var(--duration-base)] ease-[var(--ease-premium)]"
      enter-from-class="opacity-0 -translate-y-2"
      leave-active-class="transition duration-[var(--duration-fast)] ease-[var(--ease-premium)]"
      leave-to-class="opacity-0 -translate-y-2"
    >
      <nav v-if="open" class="border-t border-[var(--color-line)] bg-[var(--color-surface)] lg:hidden">
        <div class="container-app flex flex-col gap-1 py-4">
          <NuxtLink
            v-for="item in nav"
            :key="item.to"
            :to="item.to"
            class="rounded-[var(--radius-md)] px-4 py-3 text-base text-[var(--color-ink-muted)] transition-colors hover:bg-[var(--color-surface-alt)] hover:text-[var(--color-ink)]"
            active-class="bg-[var(--color-accent-soft)] text-[var(--color-accent-deep)]"
          >
            {{ item.label }}
          </NuxtLink>
          <UButton to="/contacts" color="primary" size="lg" class="mt-2">
            Обсудить проект
          </UButton>
        </div>
      </nav>
    </Transition>
  </header>
</template>
