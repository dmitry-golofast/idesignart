<script setup lang="ts">
import { computed, ref, watch } from 'vue'

/**
 * AppHeader — шапка сайта. Контент из global «header» (CMS): пункты меню,
 * телефон, кнопка действия; оформление — собственные поля global'а,
 * предзаполненные в стиле hero-блока. Бренд — из Settings.
 * Пока данные CMS пустые, работают дефолты (бывший захардкоженный список).
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
  phone?: string | null
  cta?: HeaderCtaData | null
  appearance?: Record<string, string | number | boolean | null | undefined> | null
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
const num = (v: unknown, d: number) => (typeof v === 'number' && Number.isFinite(v) ? v : d)
const bool = (v: unknown, d: boolean) => (typeof v === 'boolean' ? v : d)

const DEFAULT_NAV: NavItemData[] = [
  { label: 'Услуги', href: '/services' },
  { label: 'Портфолио', href: '/portfolio' },
  { label: 'Процесс', href: '/process' },
  { label: 'О студии', href: '/about' },
  { label: 'Блог', href: '/blog' },
  { label: 'Контакты', href: '/contacts' },
]

const nav = computed<NavItemData[]>(() => {
  const items = (hd.value.navigation ?? []).filter(
    (item) => Boolean(item?.label && item?.href),
  ) as NavItemData[]
  return items.length > 0 ? items : DEFAULT_NAV
})

const phoneText = computed(() =>
  str(hd.value.phone, '') ||
  str(props.settings?.contacts?.phone, '') ||
  str(config.public.phone as string, ''),
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

/* ---------- оформление → CSS-переменные ---------- */
const appearance = computed(() => {
  const a = hd.value.appearance ?? {}
  return {
    backgroundColor: str(a.backgroundColor, '#F8F7F3'),
    textColor: str(a.textColor, '#080808'),
    mutedTextColor: str(a.mutedTextColor, '#303030'),
    accentColor: str(a.accentColor, '#D7EF28'),
    accentTextColor: str(a.accentTextColor, '#080808'),
    fontFamily: str(a.fontFamily, 'inter'),
    brandPx: num(a.brandPx, 30),
    navigationPx: num(a.navigationPx, 16),
    buttonTextPx: num(a.buttonTextPx, 18),
    buttonHeightPx: num(a.buttonHeightPx, 56),
    buttonPaddingXPx: num(a.buttonPaddingXPx, 28),
    buttonRadiusPx: num(a.buttonRadiusPx, 0),
    headerHeightPx: num(a.headerHeightPx, 88),
  }
})

const ctaStyle = computed(() => {
  const a = appearance.value
  switch (cta.value.variant) {
    case 'dark':
      return { backgroundColor: a.textColor, color: a.backgroundColor }
    case 'outline':
      return { backgroundColor: 'transparent', color: a.textColor, border: `1px solid ${a.textColor}` }
    default:
      return { backgroundColor: a.accentColor, color: a.accentTextColor }
  }
})

const ctaAttrs = computed(() =>
  cta.value.newTab ? { target: '_blank', rel: 'noopener noreferrer' } : {},
)

const styleVars = computed(() => {
  const a = appearance.value
  return {
    '--hd-bg': a.backgroundColor,
    '--hd-text': a.textColor,
    '--hd-muted': a.mutedTextColor,
    '--hd-font': FONT_STACKS[a.fontFamily] ?? FONT_STACKS.inter,
    '--hd-brand-px': `${a.brandPx}px`,
    '--hd-nav-px': `${a.navigationPx}px`,
    '--hd-btn-text-px': `${a.buttonTextPx}px`,
    '--hd-btn-height': `${a.buttonHeightPx}px`,
    '--hd-btn-px': `${a.buttonPaddingXPx}px`,
    '--hd-btn-radius': `${a.buttonRadiusPx}px`,
    '--hd-height': `${a.headerHeightPx}px`,
  } as Record<string, string>
})
</script>

<template>
  <header class="hd" :style="styleVars">
    <div class="hd-container hd-inner">
      <!-- Лого -->
      <NuxtLink to="/" class="hd-brand">{{ props.settings?.brand?.name || 'idesignart' }}</NuxtLink>

      <!-- Десктоп-навигация -->
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
          class="hd-cta"
          :style="ctaStyle"
          v-bind="ctaAttrs"
        >
          <span>{{ cta.label }}</span>
          <svg
            v-if="cta.icon === 'arrow-up-right'"
            class="hd-cta-arrow"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2.2"
            stroke-linecap="round"
            stroke-linejoin="round"
            aria-hidden="true"
          >
            <path d="M7 17 17 7" />
            <path d="M8 7h9v9" />
          </svg>
          <svg
            v-else-if="cta.icon === 'arrow-right'"
            class="hd-cta-arrow"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2.2"
            stroke-linecap="round"
            stroke-linejoin="round"
            aria-hidden="true"
          >
            <path d="M4 12h16" />
            <path d="m13 5 7 7-7 7" />
          </svg>
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

    <!-- Мобильное меню: те же пункты из CMS (§09) -->
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
          <a v-if="cta.enabled" :href="cta.href" class="hd-cta hd-cta--mobile" :style="ctaStyle" v-bind="ctaAttrs">
            <span>{{ cta.label }}</span>
            <span aria-hidden="true">↗</span>
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
  background-color: color-mix(in srgb, var(--hd-bg) 88%, transparent);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid color-mix(in srgb, var(--hd-text) 8%, transparent);
  color: var(--hd-text);
  font-family: var(--hd-font);
}

.hd-container {
  width: 100%;
  max-width: 1600px;
  margin-inline: auto;
  padding-inline: clamp(1rem, 4vw, 3rem);
}

.hd-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  height: var(--hd-height);
}

.hd-brand {
  font-size: var(--hd-brand-px);
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--hd-text);
  text-decoration: none;
}

.hd-nav {
  display: none;
  align-items: center;
  gap: 2rem;
}

.hd-link {
  font-size: var(--hd-nav-px);
  color: var(--hd-muted);
  text-decoration: none;
  transition: color var(--duration-base) var(--ease-premium);
}

.hd-link:hover,
.hd-link--active {
  color: var(--hd-text);
}

.hd-link:focus-visible {
  outline: 2px solid var(--hd-text);
  outline-offset: 2px;
}

.hd-actions {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.hd-phone {
  display: none;
  font-size: calc(var(--hd-nav-px) - 1px);
  color: var(--hd-muted);
  text-decoration: none;
  transition: color var(--duration-base) var(--ease-premium);
}

.hd-phone:hover {
  color: var(--hd-text);
}

/* Кнопка действия — в стиле hero: лаймовый прямоугольник со стрелкой */
.hd-cta {
  display: none;
  align-items: center;
  justify-content: center;
  gap: 0.6rem;
  min-height: var(--hd-btn-height);
  padding-inline: var(--hd-btn-px);
  border-radius: var(--hd-btn-radius);
  font-size: var(--hd-btn-text-px);
  font-weight: 600;
  line-height: 1.2;
  text-decoration: none;
  transition: filter var(--duration-base) var(--ease-premium);
}

.hd-cta-arrow {
  width: 1.15em;
  height: 1.15em;
  flex-shrink: 0;
  transition: transform var(--duration-base) var(--ease-premium);
}

.hd-cta:hover {
  filter: brightness(0.94);
}

.hd-cta:hover .hd-cta-arrow {
  transform: translate(2px, -2px);
}

.hd-cta:focus-visible {
  outline: 2px solid var(--hd-text);
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
  color: var(--hd-text);
  font-size: 1.375rem;
  cursor: pointer;
}

.hd-burger:focus-visible {
  outline: 2px solid var(--hd-text);
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
  border-top: 1px solid color-mix(in srgb, var(--hd-text) 8%, transparent);
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
  color: var(--hd-muted);
  text-decoration: none;
  transition: background-color var(--duration-base) var(--ease-premium), color var(--duration-base) var(--ease-premium);
}

.hd-mobile-link:hover {
  color: var(--hd-text);
  background-color: color-mix(in srgb, var(--hd-text) 5%, transparent);
}

.hd-cta--mobile {
  display: inline-flex;
  width: 100%;
  justify-content: space-between;
  margin-top: 0.5rem;
}
</style>
