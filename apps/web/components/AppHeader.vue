<script setup lang="ts">
import { computed, ref, watch } from 'vue'

/**
 * AppHeader — шапка сайта (редизайн v3, язык ayocin).
 * Бренд слева, навигация по центру, справа — телефон и CTA-пилюля
 * со стрелкой-орбом («Order Now»-стиль). Контент из global «header»
 * (CMS): пункты меню, кнопка действия. Телефон из CMS не приходит —
 * берётся из контактов Settings, затем из env-переменной.
 * Оформление в CMS не живёт — цвета/шрифты берутся из дизайн-токенов
 * tokens.css, размеры зашиты в scoped-стилях этого компонента.
 * Бренд — из Settings. Пока данные CMS пустые, работают дефолты.
 */
interface NavItemData {
  label?: string | null
  href?: string | null
  newTab?: boolean | null
  id?: string
}

interface HeaderCtaData {
  enabled?: boolean | null
  label?: string | null
  href?: string | null
  newTab?: boolean | null
  icon?: string | null
  variant?: string | null
}

interface HeaderData {
  navigation?: NavItemData[] | null
  cta?: HeaderCtaData | null
}

interface SettingsData {
  brand?: { name?: string | null; tagline?: string | null }
  contacts?: { phone?: string | null; whatsapp?: string | null; telegram?: string | null }
}

const props = defineProps<{ settings?: SettingsData }>()

const { data: headerData } = useHeader()
const hd = computed<HeaderData>(() => (headerData.value ?? {}) as HeaderData)

const open = ref(false)
const route = useRoute()
const config = useRuntimeConfig()

// Закрытие меню при клике на ссылку и по Escape
watch(() => route.fullPath, () => { open.value = false })
if (import.meta.client) {
  watch(open, (value) => {
    if (!value) return
    const onKey = (event: KeyboardEvent) => {
      if (event.key === 'Escape') open.value = false
    }
    document.addEventListener('keydown', onKey, { once: true })
  })
}

/* ---------- безопасное чтение полей CMS ---------- */
const str = (v: unknown, d: string) => (typeof v === 'string' && v.length > 0 ? v : d)
const bool = (v: unknown, d: boolean) => (typeof v === 'boolean' ? v : d)

// Якорные пункты прокручивают до блоков на главной; «О студии» и «Блог» — страницы
const DEFAULT_NAV: NavItemData[] = [
  { label: 'Услуги', href: '/#services-grid' },
  { label: 'Портфолио', href: '/#portfolio-grid' },
  { label: 'Процесс', href: '/#process-steps' },
  { label: 'О студии', href: '/about' },
  { label: 'Блог', href: '/blog' },
  { label: 'Контакты', href: '/#contact-form' },
]

const nav = computed<NavItemData[]>(() => {
  const items = (hd.value.navigation ?? []).filter(
    (item) => Boolean(item?.label && item?.href),
  ) as NavItemData[]
  return items.length > 0 ? items : DEFAULT_NAV
})

// Телефон из CMS не приходит: сначала контакты Settings, затем env-переменная
const phoneText = computed(
  () => str(props.settings?.contacts?.phone, '') || str(config.public.phone as string, ''),
)
const phoneHref = computed(() =>
  phoneText.value ? `tel:${phoneText.value.replace(/[^\d+]/g, '')}` : '',
)

const cta = computed(() => {
  const c = hd.value.cta ?? {}
  return {
    enabled: bool(c.enabled, true),
    label: str(c.label, 'Обсудить проект'),
    href: typeof c.href === 'string' && c.href ? c.href : '/contacts',
    newTab: bool(c.newTab, false),
    icon: str(c.icon, 'arrow-up-right'),
    variant: str(c.variant, 'accent'),
  }
})

const ctaClass = computed(() => {
  switch (cta.value.variant) {
    case 'dark':
      return 'hd-cta hd-cta--light'
    case 'outline':
      return 'hd-cta hd-cta--outline'
    default:
      return 'hd-cta'
  }
})

const ctaAttrs = computed(() =>
  cta.value.newTab ? { target: '_blank', rel: 'noopener noreferrer' } : {},
)
</script>

<template>
  <header class="hd">
    <div class="hd-container hd-inner">
      <!-- Лого -->
      <NuxtLink to="/" class="hd-brand">{{ props.settings?.brand?.name || 'idesignart' }}</NuxtLink>

      <!-- Десктоп-навигация по центру -->
      <nav class="hd-nav" aria-label="Основная навигация">
        <NuxtLink
          v-for="item in nav"
          :key="item.id ?? (item.href || '')"
          :to="item.href ?? ''"
          :target="item.newTab ? '_blank' : undefined"
          :rel="item.newTab ? 'noopener noreferrer' : undefined"
          class="hd-link"
          active-class="hd-link--active"
        >
          {{ item.label }}
        </NuxtLink>
      </nav>

      <!-- Телефон + кнопка + бургер -->
      <div class="hd-actions">
        <a v-if="phoneHref" :href="phoneHref" class="hd-phone">{{ phoneText }}</a>

        <a
          v-if="cta.enabled"
          :href="cta.href"
          :class="ctaClass"
          v-bind="ctaAttrs"
        >
          <span>{{ cta.label }}</span>
          <span class="hd-cta-orb" aria-hidden="true">
            <svg
              v-if="cta.icon === 'arrow-up-right'"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2.2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path d="M7 17 17 7" />
              <path d="M8 7h9v9" />
            </svg>
            <svg
              v-else-if="cta.icon === 'arrow-right'"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2.2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path d="M4 12h16" />
              <path d="m13 5 7 7-7 7" />
            </svg>
          </span>
        </a>

        <button
          class="hd-burger"
          type="button"
          :aria-expanded="open"
          aria-label="Меню"
          @click="open = !open"
        >
          <UIcon :name="open ? 'i-lucide-x' : 'i-lucide-menu'" />
        </button>
      </div>
    </div>

    <!-- Мобильное меню: те же пункты из CMS -->
    <Transition
      enter-active-class="transition duration-[var(--duration-base)] ease-[var(--ease-premium)]"
      enter-from-class="opacity-0 -translate-y-2"
      leave-active-class="transition duration-[var(--duration-fast)] ease-[var(--ease-premium)]"
      leave-to-class="opacity-0 -translate-y-2"
    >
      <nav v-if="open" class="hd-mobile" aria-label="Мобильная навигация">
        <div class="hd-container hd-mobile-inner">
          <NuxtLink
            v-for="item in nav"
            :key="item.id ?? (item.href || '')"
            :to="item.href ?? ''"
            :target="item.newTab ? '_blank' : undefined"
            :rel="item.newTab ? 'noopener noreferrer' : undefined"
            class="hd-mobile-link"
          >
            {{ item.label }}
          </NuxtLink>
          <a v-if="phoneHref" :href="phoneHref" class="hd-mobile-link">{{ phoneText }}</a>
          <a v-if="cta.enabled" :href="cta.href" :class="ctaClass" class="hd-cta--mobile" v-bind="ctaAttrs">
            <span>{{ cta.label }}</span>
            <span class="hd-cta-orb" aria-hidden="true">↗</span>
          </a>
        </div>
      </nav>
    </Transition>
  </header>
</template>

<style scoped>
.hd {
  position: sticky;
  top: 0;
  z-index: var(--z-header);
  /* Общая высота шапки (включая нижнюю линию) = --header-height (tokens.css):
     эту же величину из вьюпорта вычитают блоки первого экрана */
  height: var(--header-height);
  box-sizing: border-box;
  background-color: color-mix(in srgb, var(--color-canvas) 90%, transparent);
  backdrop-filter: blur(14px);
  border-bottom: 1px solid var(--color-line);
  color: var(--color-ink);
  font-family: var(--font-sans);
}

.hd-container {
  width: 100%;
  max-width: var(--container-max);
  margin-inline: auto;
  padding-inline: clamp(1rem, 4vw, 4rem);
}

.hd-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  height: calc(var(--header-height) - 1px); /* минус нижняя линия шапки */
}

.hd-brand {
  font-size: 1.375rem; /* 22px */
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--color-ink);
  text-decoration: none;
}

.hd-nav {
  display: none;
  align-items: center;
  gap: 2rem;
}

.hd-link {
  position: relative;
  font-size: 0.9375rem; /* 15px */
  color: var(--color-ink-muted);
  text-decoration: none;
  transition: color var(--duration-base) var(--ease-premium);
}

.hd-link::after {
  content: "";
  position: absolute;
  left: 0;
  bottom: -6px;
  width: 100%;
  height: 1px;
  background-color: var(--color-ink);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform var(--duration-base) var(--ease-premium);
}

.hd-link:hover,
.hd-link--active {
  color: var(--color-ink);
}

.hd-link:hover::after {
  transform: scaleX(1);
}

.hd-link--active {
  color: var(--color-ink);
}

.hd-link:focus-visible {
  outline: 2px solid var(--color-ink);
  outline-offset: 2px;
}

.hd-actions {
  display: flex;
  align-items: center;
  gap: 1.25rem;
}

.hd-phone {
  display: none;
  font-size: 0.875rem; /* 14px */
  color: var(--color-ink-muted);
  text-decoration: none;
  transition: color var(--duration-base) var(--ease-premium);
}

.hd-phone:hover {
  color: var(--color-ink);
}

/* Кнопка действия — пилюля со стрелкой-орбом («Order Now» ayocin) */
.hd-cta {
  display: none;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  min-height: 3rem;
  padding: 0.25rem 0.25rem 0.25rem 1.375rem;
  border-radius: var(--radius-pill);
  background-color: var(--color-accent);
  color: var(--color-accent-contrast);
  font-size: 0.875rem;
  font-weight: 600;
  line-height: 1;
  text-decoration: none;
  transition: background-color var(--duration-base) var(--ease-premium),
    transform var(--duration-fast) var(--ease-premium);
}

.hd-cta-orb {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2.125rem;
  height: 2.125rem;
  border-radius: 50%;
  background-color: var(--color-canvas);
  color: var(--color-ink);
  font-size: 0.875rem;
  flex-shrink: 0;
}

.hd-cta svg {
  width: 0.8125rem;
  height: 0.8125rem;
  transition: transform var(--duration-base) var(--ease-premium);
}

.hd-cta:hover svg {
  transform: translate(2px, -2px);
}

/* Вариант dark: светлая пилюля */
.hd-cta--light {
  background-color: var(--color-canvas);
  color: var(--color-ink);
}
.hd-cta--light .hd-cta-orb {
  background-color: var(--color-ink);
  color: var(--color-canvas);
}

/* Вариант outline: прозрачная с hairline */
.hd-cta--outline {
  background-color: transparent;
  color: var(--color-ink);
  border: 1px solid color-mix(in srgb, var(--color-ink) 40%, transparent);
}
.hd-cta--outline .hd-cta-orb {
  background-color: var(--color-ink);
  color: var(--color-canvas);
}

.hd-cta:focus-visible {
  outline: 2px solid var(--color-ink);
  outline-offset: 2px;
}

.hd-burger {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2.5rem;
  height: 2.5rem;
  border: none;
  background: transparent;
  color: var(--color-ink);
  font-size: 1.375rem;
  cursor: pointer;
}

.hd-burger:focus-visible {
  outline: 2px solid var(--color-ink);
  outline-offset: 2px;
}

@media (min-width: 768px) {
  .hd-cta {
    display: inline-flex;
  }
}

@media (min-width: 1024px) {
  .hd-nav {
    display: flex;
  }

  .hd-phone {
    display: inline;
  }

  .hd-burger {
    display: none;
  }
}

/* Мобильное меню */
.hd-mobile {
  border-top: 1px solid var(--color-line);
}

.hd-mobile-inner {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 0.25rem;
  padding-block: 1rem;
}

.hd-mobile-link {
  width: 100%;
  padding: 0.75rem 1rem;
  border-radius: var(--radius-md);
  font-size: 1rem;
  color: var(--color-ink-muted);
  text-decoration: none;
  transition: background-color var(--duration-base) var(--ease-premium), color var(--duration-base) var(--ease-premium);
}

.hd-mobile-link:hover {
  color: var(--color-ink);
  background-color: color-mix(in srgb, var(--color-ink) 5%, transparent);
}

.hd-cta--mobile {
  display: inline-flex;
  width: 100%;
  justify-content: space-between;
  margin-top: 0.5rem;
}
</style>
