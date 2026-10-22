<script setup lang="ts">
import { computed } from 'vue'

/**
 * AppFooter — подвал (редизайн v3, язык ayocin).
 * Тёмная эспрессо-панель: колонки с caps-заголовками, крупный email
 * как центральный контакт, соцсети текстом, нижняя строка с copyright,
 * политикой и gold-чипом. Колонка «Услуги» — те же featured-услуги из
 * CMS, что в блоке «Чем мы можем помочь» (статичный список — фолбэк).
 */

interface SettingsData {
  brand?: { name?: string | null; tagline?: string | null }
  contacts?: { email?: string | null; phone?: string | null; whatsapp?: string | null; telegram?: string | null; instagram?: string | null; address?: string | null }
}

const props = defineProps<{ settings?: SettingsData }>()
const config = useRuntimeConfig()

const brand = computed(() => props.settings?.brand?.name || 'idesignart')
const tagline = computed(() => props.settings?.brand?.tagline || 'Дизайн интерьера и 3D-визуализация')
// Контакты из Settings; фолбэк — public-конфиг (env), чтобы футер не оставался
// пустым, пока глобал «Настройки» не заполнен в админке
const contacts = computed(() => ({
  email: props.settings?.contacts?.email || (config.public.email as string) || '',
  phone: props.settings?.contacts?.phone || (config.public.phone as string) || '',
  whatsapp: props.settings?.contacts?.whatsapp || (config.public.whatsapp as string) || '',
  telegram: props.settings?.contacts?.telegram || (config.public.telegram as string) || '',
  address: props.settings?.contacts?.address || '',
}))

const year = new Date().getFullYear()

// Услуги — тот же список, что показывает блок «Чем мы можем помочь»
// на главной: опубликованные featured-услуги из CMS, по порядку order
// (useFetch дедуплицируется по ключу с запросом этого блока).
// Пока CMS пуст — статичный фолбэк, как DEFAULT_NAV в шапке.
const DEFAULT_SERVICE_LINKS = [
  { label: 'Дизайн квартиры', to: '/services/apartment-design' },
  { label: 'Дизайн офиса', to: '/services/office-design' },
  { label: '3D-визуализация', to: '/services/3d-visualization' },
  { label: 'Планировочные решения', to: '/services/space-planning' },
  { label: 'Авторский надзор', to: '/services/author-supervision' },
]

const { data: servicesData } = useServices({ featuredOnly: true })
const serviceLinks = computed(() => {
  const docs = servicesData.value?.docs ?? []
  const links = docs
    .filter((s) => s.title && s.slug)
    .map((s) => ({ label: s.title as string, to: `/services/${s.slug}` }))
  return links.length > 0 ? links : DEFAULT_SERVICE_LINKS
})

const studioLinks = [
  { label: 'Портфолио', to: '/#portfolio-grid' },
  { label: 'О нас', to: '/about' },
  { label: 'Процесс работы', to: '/#process-steps' },
  { label: 'Блог', to: '/blog' },
  { label: 'Контакты', to: '/#contact-form' },
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
  <footer class="ft bg-[var(--color-espresso)] text-[#f6f1e7]">
    <div class="container-app pt-16 pb-8 lg:pt-24">
      <div class="grid gap-12 lg:grid-cols-[1.4fr_1fr_1fr_1.4fr] lg:gap-8">
        <!-- Бренд + описание + соцсети -->
        <div>
          <div class="font-display text-2xl font-extrabold tracking-[-0.02em]">{{ brand }}</div>
          <p class="mt-3 max-w-xs text-sm leading-relaxed text-[#f6f1e7]/60">
            {{ tagline }}
          </p>
          <ul v-if="whatsappUrl || telegramUrl" class="mt-8 space-y-2.5">
            <li v-if="whatsappUrl">
              <a
                :href="whatsappUrl"
                target="_blank"
                rel="noopener noreferrer"
                class="ft-link"
              >WhatsApp <span aria-hidden="true" class="text-[#f6f1e7]/40">↗</span></a>
            </li>
            <li v-if="telegramUrl">
              <a
                :href="telegramUrl"
                target="_blank"
                rel="noopener noreferrer"
                class="ft-link"
              >Telegram <span aria-hidden="true" class="text-[#f6f1e7]/40">↗</span></a>
            </li>
          </ul>
        </div>

        <!-- Услуги -->
        <nav aria-label="Услуги в подвале">
          <h3 class="ft-col-title">Услуги</h3>
          <ul class="space-y-2.5">
            <li v-for="link in serviceLinks" :key="link.to">
              <NuxtLink :to="link.to" class="ft-link">{{ link.label }}</NuxtLink>
            </li>
          </ul>
        </nav>

        <!-- Студия -->
        <nav aria-label="Навигация в подвале">
          <h3 class="ft-col-title">Студия</h3>
          <ul class="space-y-2.5">
            <li v-for="link in studioLinks" :key="link.to">
              <NuxtLink :to="link.to" class="ft-link">{{ link.label }}</NuxtLink>
            </li>
          </ul>
        </nav>

        <!-- Контакты: крупный email как у ayocin -->
        <div>
          <h3 class="ft-col-title">Контакты</h3>
          <a
            v-if="contacts.email"
            :href="`mailto:${contacts.email}`"
            class="mt-2 block font-display text-[clamp(1.375rem,2vw,1.875rem)] font-semibold tracking-[-0.02em] text-[#f6f1e7] no-underline transition-opacity hover:opacity-75"
          >
            {{ contacts.email }}
          </a>
          <ul class="mt-5 space-y-2.5 text-sm text-[#f6f1e7]/60">
            <li v-if="contacts.phone">
              <a :href="`tel:${contacts.phone}`" class="ft-link !text-[#f6f1e7]/60">{{ contacts.phone }}</a>
            </li>
            <li v-if="contacts.address" class="pt-1 leading-relaxed">
              {{ contacts.address }}
            </li>
          </ul>
        </div>
      </div>

      <!-- Нижняя строка -->
      <div class="mt-16 flex flex-col items-start justify-between gap-5 border-t border-[#f6f1e7]/12 pt-6 text-xs text-[#f6f1e7]/45 sm:flex-row sm:items-center">
        <p>© {{ year }} {{ brand }}. Все права защищены.</p>
        <NuxtLink to="/privacy" class="transition-colors hover:text-[#f6f1e7]">
          Политика конфиденциальности
        </NuxtLink>
        <span class="chip-outline !border-[#e0b73f]/70 !text-[#e0b73f]">{{ brand }} — дизайн интерьеров</span>
      </div>
    </div>
  </footer>
</template>

<style scoped>
/* Caps-заголовки колонок — muted, как у ayocin (INSIDER CIRCLE / CONTACT / …) */
.ft-col-title {
  margin-bottom: 1.25rem;
  font-size: 0.6875rem;
  font-weight: 600;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: rgba(246, 241, 231, 0.45);
}

.ft-link {
  font-size: 0.9375rem;
  color: rgba(246, 241, 231, 0.72);
  text-decoration: none;
  transition: color var(--duration-base) var(--ease-premium);
}

.ft-link:hover {
  color: #f6f1e7;
}
</style>
