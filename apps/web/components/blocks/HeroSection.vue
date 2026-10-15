<script setup lang="ts">
/**
 * HeroSection — главный экран в языке ayocin.com (редизайн v3):
 * панорамное фото-фон во весь экран, над ним гигантский заголовок
 * во всю ширину (строки выезжают из-под маски), угловые метаданные
 * («• eyebrow», «© год»), внизу — описание, CTA-пилюля со стрелкой
 * и нижняя строка с hairline.
 *
 * Тексты и медиа приходят из CMS (Pages → блок hero): eyebrow,
 * titleLines, description, cta, image/mobileImage, imageCaption.
 * Контентные кадрировки (object-position, затемнение) — из CMS,
 * оформление — статичные токены.
 */
interface HeroCtaData {
  enabled?: boolean | null
  label?: string | null
  href?: string | null
  newTab?: boolean | null
  icon?: 'arrow-up-right' | 'arrow-right' | 'none' | string | null
  variant?: 'accent' | 'dark' | 'outline' | string | null
}

interface HeroMediaData {
  url?: string | null
  alt?: string | null
}

interface HeroData {
  eyebrow?: string | null
  titleLines?: { text?: string; id?: string }[] | null
  description?: string | null
  cta?: HeroCtaData | null
  image?: HeroMediaData | number | null
  mobileImage?: HeroMediaData | number | null
  imageAlt?: string | null
  mobileImageAlt?: string | null
  imageCaption?: string | null
  showImageCaption?: boolean | null
  imagePositionX?: number | null
  imagePositionY?: number | null
  mobileImagePositionX?: number | null
  mobileImagePositionY?: number | null
  captionOverlayOpacity?: number | null
}

/** Нормализованные поля hero: без null/undefined — шаблон работает с чистыми типами */
interface HeroViewData {
  eyebrow: string
  titleLines: { text: string; id?: string }[]
  description: string
  imageAlt: string
  mobileImageAlt: string
  imageCaption: string
  showImageCaption: boolean
  imagePositionX: number
  imagePositionY: number
  mobileImagePositionX: number
  mobileImagePositionY: number
  captionOverlayOpacity: number
  image?: HeroMediaData | number | null
  mobileImage?: HeroMediaData | number | null
}

// inheritAttrs: false — CMS может присылать поле bottomLine, но компонент
// от него не зависит; без этого флага объект попал бы атрибутом в DOM.
defineOptions({ inheritAttrs: false })

const props = defineProps<{
  hero?: HeroData | null
}>()

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

/* ---------- безопасное чтение полей со значениями по умолчанию ---------- */
const str = (v: unknown, d: string) => (typeof v === 'string' && v.length > 0 ? v : d)
const num = (v: unknown, d: number) => (typeof v === 'number' && Number.isFinite(v) ? v : d)
const bool = (v: unknown, d: boolean) => (typeof v === 'boolean' ? v : d)

const hero = computed<HeroViewData>(() => {
  const h = props.hero ?? {}
  return {
    eyebrow: str(h.eyebrow, 'ЦИФРОВОЙ ДИЗАЙН ИНТЕРЬЕРОВ'),
    titleLines: (h.titleLines ?? []).filter(
      (l): l is { text: string; id?: string } => typeof l?.text === 'string' && l.text.length > 0,
    ),
    description: str(h.description, 'Превращаем пустые комнаты в выразительные интерьеры для продажи недвижимости.'),
    imageAlt: str(h.imageAlt, 'Светлая гостиная с панорамными окнами'),
    mobileImageAlt: str(h.mobileImageAlt || h.imageAlt, ''),
    imageCaption: h.imageCaption ?? '01 / Тёплый минимализм',
    showImageCaption: bool(h.showImageCaption, true),
    imagePositionX: num(h.imagePositionX, 50),
    imagePositionY: num(h.imagePositionY, 50),
    mobileImagePositionX: num(h.mobileImagePositionX, 50),
    mobileImagePositionY: num(h.mobileImagePositionY, 50),
    captionOverlayOpacity: num(h.captionOverlayOpacity, 0.32),
    image: h.image ?? null,
    mobileImage: h.mobileImage ?? null,
  }
})

const cta = computed<{ enabled: boolean; label: string; href: string; newTab: boolean; variant: string; icon: string }>(() => {
  const c = props.hero?.cta ?? {}
  return {
    enabled: bool(c.enabled, true),
    label: c.label ?? 'Создать интерьер',
    href: typeof c.href === 'string' ? c.href : '',
    newTab: bool(c.newTab, false),
    variant: c.variant ?? 'accent',
    icon: c.icon ?? 'arrow-up-right',
  }
})

/* ---------- медиа ---------- */
const absUrl = (url?: string | null) =>
  url ? (url.startsWith('http') ? url : `${payloadBase}${url}`) : ''

const isMedia = (m: unknown): m is HeroMediaData =>
  Boolean(m) && typeof m === 'object' && typeof (m as HeroMediaData).url === 'string'

const desktopImage = computed(() => (isMedia(hero.value.image) ? hero.value.image : null))
const mobileImage = computed(() => (isMedia(hero.value.mobileImage) ? hero.value.mobileImage : null))

const desktopUrl = computed(() => absUrl(desktopImage.value?.url))
const mobileUrl = computed(() => absUrl(mobileImage.value?.url ?? desktopImage.value?.url))

/** Есть ли фон-фото: на нём текст кремовый, без — тёмный на креме */
const hasPhoto = computed(() => Boolean(desktopUrl.value))

/* ---------- контентные CSS-переменные из CMS ---------- */
const styleVars = computed(() => ({
  '--h-shade': String(hero.value.captionOverlayOpacity),
  '--h-img-pos-d': `${hero.value.imagePositionX}% ${hero.value.imagePositionY}%`,
  '--h-img-pos-m': `${hero.value.mobileImagePositionX}% ${hero.value.mobileImagePositionY}%`,
}) as Record<string, string>)

/* ---------- кнопка ---------- */
const ctaVisible = computed(() => cta.value.enabled && Boolean(cta.value.href))

const ctaClass = computed(() => {
  switch (cta.value.variant) {
    case 'dark':
      return 'hero-cta btn-pill btn-pill-light'
    case 'outline':
      return 'hero-cta btn-pill hero-cta--outline'
    default:
      // accent на фото — светлая пилюля (читаемее), без фото — тёмная
      return hasPhoto.value ? 'hero-cta btn-pill btn-pill-light' : 'hero-cta btn-pill'
  }
})

const ctaAttrs = computed(() =>
  cta.value.newTab
    ? { target: '_blank', rel: 'noopener noreferrer' }
    : {},
)

/** Иконка CMS-CTA → имя Iconify (lucide); '' — орб-стрелка не рисуется */
const ctaOrbIcon = computed(() => {
  switch (cta.value.icon) {
    case 'arrow-up-right':
      return 'i-lucide-arrow-up-right'
    case 'arrow-right':
      return 'i-lucide-arrow-right'
    default:
      return ''
  }
})
</script>

<template>
  <section class="hero" :class="{ 'hero--photo': hasPhoto }" :style="styleVars">
    <!-- Фон-фото: во всю секцию, объект-кавер; затемнение снизу под текст -->
    <div v-if="hasPhoto" class="hero-bg" aria-hidden="true">
      <picture>
        <source v-if="mobileUrl && mobileImage" media="(max-width: 767px)" :srcset="mobileUrl" />
        <img
          class="hero-bg-img"
          :src="desktopUrl"
          :alt="hero.imageAlt"
          fetchpriority="high"
          decoding="async"
        />
      </picture>
      <div class="hero-shade" />
    </div>

    <div class="hero-container">
      <!-- Гигантский заголовок во всю ширину, строки из-под маски -->
      <h1 v-if="hero.titleLines.length" class="hero-title" data-reveal-line>
        <span
          v-for="(line, i) in hero.titleLines"
          :key="line.id ?? i"
          class="reveal-line"
          :style="{ '--reveal-delay': `${120 + i * 140}ms` }"
        >
          <span class="reveal-line-inner">{{ line.text }}</span>
        </span>
      </h1>

      <!-- Угловые метаданные под заголовком: линия отрисовывается
           слева направо (animate-line-draw), текст появляется следом -->
      <div v-if="hero.eyebrow" class="hero-meta">
        <span
          class="hero-meta-line origin-left animate-line-draw"
          aria-hidden="true"
          data-reveal="fade"
          style="--reveal-delay: 200ms"
        />
        <div class="hero-meta-row" data-reveal="fade" style="--reveal-delay: 850ms">
          <p class="meta-label">{{ hero.eyebrow }}</p>
          <span class="hero-meta-right">© {{ new Date().getFullYear() }}</span>
        </div>
      </div>

      <!-- Низ: описание + CTA слева, caption справа -->
      <div class="hero-foot">
        <div class="hero-foot-main">
          <p v-if="hero.description" class="hero-description" data-reveal style="--reveal-delay: 420ms">
            {{ hero.description }}
          </p>

          <UButton
            v-if="ctaVisible"
            :to="cta.href"
            size="xl"
            color="neutral"
            variant="soft"
            :class="ctaClass"
            style="--reveal-delay: 560ms"
            data-reveal
            v-bind="ctaAttrs"
          >
            {{ cta.label }}
            <span v-if="ctaOrbIcon" class="btn-pill-orb" aria-hidden="true">
              <UIcon :name="ctaOrbIcon" />
            </span>
          </UButton>
        </div>

        <p
          v-if="hero.showImageCaption && hero.imageCaption && hasPhoto"
          class="hero-caption"
          data-reveal="fade"
          style="--reveal-delay: 700ms"
        >
          {{ hero.imageCaption }}
        </p>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* =========================================================
 * Hero v3 — язык ayocin: полноэкранная секция, фото-фон,
 * гигантский заголовок, угловые метаданные.
 * ========================================================= */
.hero {
  --h-text: var(--color-ink);
  --h-muted: var(--color-ink-muted);
  --h-onphoto: #fdfaf3; /* крем-текст на фото */

  position: relative;
  display: flex;
  flex-direction: column;
  /* Весь первый экран: вьюпорт минус sticky-шапка (--hd-height задаёт AppHeader на <html>).
     Фолбэки: vh для старых браузеров → svh → dvh (актуальная высота с панелями мобильных) */
  min-height: calc(100vh - var(--hd-height, 76px));
  min-height: calc(100svh - var(--hd-height, 76px));
  min-height: calc(100dvh - var(--hd-height, 76px));
  background-color: var(--color-canvas);
  color: var(--h-text);
  font-family: var(--font-display);
  overflow: hidden;
}

.hero--photo {
  color: var(--h-onphoto);
}

/* ---------- фон-фото ---------- */
.hero-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
  isolation: isolate;
}

.hero-bg-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: var(--h-img-pos-m);
}

@media (min-width: 768px) {
  .hero-bg-img {
    object-position: var(--h-img-pos-d);
  }
}

/* Мягкое затемнение: сильнее у нижней кромки — под описание и caption.
   На всю высоту — лёгкий тёплый тон, чтобы заголовок читался на любом фото */
.hero-shade {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(
      to top,
      rgba(24, 18, 13, 0.78) 0%,
      rgba(24, 18, 13, calc(var(--h-shade) * 0.9)) 32%,
      rgba(24, 18, 13, calc(var(--h-shade) * 0.42)) 62%,
      rgba(24, 18, 13, 0.18) 100%
    );
  pointer-events: none;
}

/* ---------- контент: компактная группа по центру вертикали ---------- */
.hero-container {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: var(--container-max);
  margin-inline: auto;
  padding-inline: var(--container-pad);
  display: flex;
  flex-direction: column;
  justify-content: center;
  flex: 1 1 auto;
  padding-top: clamp(5rem, 10vh, 7rem); /* место под sticky-шапку */
  padding-bottom: 1.25rem;
}

/* Заголовок — гигантский, во всю ширину (ayocin «ATMOS LAMP») */
.hero-title {
  margin: 0;
  font-weight: 800;
  font-size: clamp(3rem, 10.5vw, 13rem);
  line-height: 0.96;
  letter-spacing: -0.04em;
  text-transform: uppercase;
  color: currentColor;
  overflow-wrap: anywhere;
}

/* ---------- метаданные-углы: линия + строка под ней ---------- */
.hero-meta {
  display: flex;
  flex-direction: column;
  margin-top: clamp(1.25rem, 3vh, 2.25rem);
}

/* Hairline — рисуется утилитой animate-line-draw (scaleX слева направо) */
.hero-meta-line {
  display: block;
  height: 1px;
  width: 100%;
  background-color: color-mix(in srgb, currentColor 26%, transparent);
}

.hero--photo .hero-meta-line {
  background-color: rgba(253, 250, 243, 0.32);
}

/* Анимация стартует только когда reveal-система добавит .is-revealed
   (сам элемент с data-reveal="fade"). Без JS класс .has-js не ставится:
   анимация не на паузе — линия просто отрисовывается при загрузке */
.has-js .hero-meta-line {
  animation-play-state: paused;
}

.has-js .hero-meta-line.is-revealed {
  animation-play-state: running;
}

.hero-meta-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  padding-top: 1rem;
}

.meta-label {
  color: currentColor;
  opacity: 0.85;
}

.hero-meta-right {
  font-size: var(--text-micro);
  letter-spacing: 0.12em;
  color: currentColor;
  opacity: 0.7;
}

/* ---------- низ секции: описание и CTA примыкают к группе ---------- */
.hero-foot {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 2rem;
  margin-top: clamp(1.5rem, 4vh, 2.75rem);
}

.hero-foot-main {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 1.75rem;
  max-width: 34rem;
}

.hero-description {
  margin: 0;
  font-size: clamp(1.125rem, 1.8vw, 1.5rem);
  line-height: 1.35;
  letter-spacing: -0.01em;
  color: currentColor;
}

/* ---------- кнопка: крупнее обычных пилюль — главный CTA страницы.
   Scoped-стили без каскадных слоёв, поэтому перебивают утилиты UButton
   (rounded-md, font-medium, px/py, gap-2, bg-elevated): форму и цвет
   вариантов дублируем здесь из main.css, layered-глобальные классы
   (.btn-pill, .btn-pill-light) утилитами перекрываются ---------- */
.hero-cta {
  min-height: 4.25rem;
  gap: 1rem;
  padding: 0.625rem 0.625rem 0.625rem 1.75rem;
  font-size: 1.0625rem;
  font-weight: 600;
  border-radius: var(--radius-pill);
  transition: background-color var(--duration-base) var(--ease-premium),
    transform var(--duration-fast) var(--ease-premium);
}

/* тёмная эспрессо-пилюля (accent без фото) */
.hero-cta:not(.hero-cta--outline) {
  background-color: var(--color-accent);
  color: var(--color-accent-contrast);
}
.hero-cta:not(.hero-cta--outline):hover {
  background-color: var(--color-espresso-soft);
}
.hero-cta:not(.hero-cta--outline):active {
  transform: translateY(1px);
}

/* крем-пилюля на фото / вариант dark */
.hero-cta.btn-pill-light {
  background-color: var(--color-canvas);
  color: var(--color-ink);
}
.hero-cta.btn-pill-light:hover {
  background-color: #ffffff;
}

.hero-cta .btn-pill-orb {
  width: 2.875rem;
  height: 2.875rem;
}

/* UIcon рендерит иконку span-ом с CSS-маской (svg нет) */
.hero-cta .btn-pill-orb .iconify {
  width: 1.125rem;
  height: 1.125rem;
  transition: transform var(--duration-base) var(--ease-premium);
}
.hero-cta:hover .btn-pill-orb .iconify {
  transform: translate(2px, -2px);
}

.hero-cta--outline {
  background-color: transparent;
  border: 1px solid color-mix(in srgb, currentColor 55%, transparent);
  color: currentColor;
}
.hero-cta--outline .btn-pill-orb {
  background-color: currentColor;
  color: var(--color-canvas);
}
.hero-cta--outline:hover {
  background-color: color-mix(in srgb, currentColor 12%, transparent);
}

.hero-caption {
  margin: 0;
  font-size: var(--text-micro);
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: currentColor;
  opacity: 0.75;
  white-space: nowrap;
}

@media (max-width: 639px) {
  .hero-foot {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
