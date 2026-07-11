<script setup lang="ts">
import { computed } from 'vue'

interface SettingsData {
  brand?: { name?: string; tagline?: string }
  contacts?: { email?: string; phone?: string; whatsapp?: string; telegram?: string; instagram?: string; address?: string }
}

const props = defineProps<{ settings?: { value?: SettingsData } }>()
const config = useRuntimeConfig()

const brand = computed(() => props.settings?.value?.brand?.name || 'idesignart')
const tagline = computed(() => props.settings?.value?.brand?.tagline || 'Дизайн интерьера и 3D-визуализация')
const contacts = computed(() => props.settings?.value?.contacts || {})

const year = new Date().getFullYear()

const cols = [
  {
    title: 'Услуги',
    links: [
      { label: 'Дизайн квартиры', to: '/services/apartment-design' },
      { label: 'Дизайн офиса', to: '/services/office-design' },
      { label: '3D-визуализация', to: '/services/3d-visualization' },
      { label: 'Планировочные решения', to: '/services/space-planning' },
      { label: 'Авторский надзор', to: '/services/author-supervision' },
    ],
  },
  {
    title: 'Студия',
    links: [
      { label: 'Портфолио', to: '/portfolio' },
      { label: 'О нас', to: '/about' },
      { label: 'Процесс работы', to: '/process' },
      { label: 'Блог', to: '/blog' },
      { label: 'Контакты', to: '/contacts' },
    ],
  },
]

const whatsappUrl = computed(() =>
  contacts.value.whatsapp
    ? `https://wa.me/${contacts.value.whatsapp}`
    : '',
)
const telegramUrl = computed(() =>
  contacts.value.telegram
    ? `https://t.me/${contacts.value.telegram}`
    : '',
)
</script>

<template>
  <footer class="border-t border-[var(--color-line)] bg-[var(--color-ink)] text-[var(--color-canvas)]">
    <div class="container-app section-sm">
      <div class="grid gap-12 lg:grid-cols-[1.5fr_1fr_1fr_1.5fr]">
        <!-- Бренд + описание -->
        <div>
          <div class="font-display text-2xl">{{ brand }}</div>
          <p class="mt-3 max-w-xs text-sm text-[var(--color-canvas)]/70">
            {{ tagline }}
          </p>
          <div v-if="whatsappUrl || telegramUrl" class="mt-6 flex gap-3">
            <UButton
              v-if="whatsappUrl"
              :to="whatsappUrl"
              icon="i-lucide-message-circle"
              color="neutral"
              variant="outline"
              size="sm"
              external
              target="_blank"
            >
              WhatsApp
            </UButton>
            <UButton
              v-if="telegramUrl"
              :to="telegramUrl"
              icon="i-lucide-send"
              color="neutral"
              variant="outline"
              size="sm"
              external
              target="_blank"
            >
              Telegram
            </UButton>
          </div>
        </div>

        <!-- Колонки навигации -->
        <div v-for="col in cols" :key="col.title">
          <h3 class="mb-4 text-xs uppercase tracking-[var(--tracking-caps)] text-[var(--color-canvas)]/50">
            {{ col.title }}
          </h3>
          <ul class="space-y-2.5">
            <li v-for="link in col.links" :key="link.to">
              <NuxtLink
                :to="link.to"
                class="text-sm text-[var(--color-canvas)]/70 transition-colors hover:text-[var(--color-canvas)]"
              >
                {{ link.label }}
              </NuxtLink>
            </li>
          </ul>
        </div>

        <!-- Контакты -->
        <div>
          <h3 class="mb-4 text-xs uppercase tracking-[var(--tracking-caps)] text-[var(--color-canvas)]/50">
            Контакты
          </h3>
          <ul class="space-y-2.5 text-sm text-[var(--color-canvas)]/70">
            <li v-if="contacts.email">
              <a :href="`mailto:${contacts.email}`" class="transition-colors hover:text-[var(--color-canvas)]">
                {{ contacts.email }}
              </a>
            </li>
            <li v-if="contacts.phone">
              <a :href="`tel:${contacts.phone}`" class="transition-colors hover:text-[var(--color-canvas)]">
                {{ contacts.phone }}
              </a>
            </li>
            <li v-if="contacts.address" class="pt-2">
              {{ contacts.address }}
            </li>
          </ul>
        </div>
      </div>

      <!-- Нижняя строка -->
      <div class="mt-12 flex flex-col items-start justify-between gap-4 border-t border-[var(--color-canvas)]/10 pt-6 text-xs text-[var(--color-canvas)]/50 sm:flex-row sm:items-center">
        <p>© {{ year }} {{ brand }}. Все права защищены.</p>
        <div class="flex gap-6">
          <NuxtLink to="/privacy" class="transition-colors hover:text-[var(--color-canvas)]">Политика конфиденциальности</NuxtLink>
        </div>
      </div>
    </div>
  </footer>
</template>
