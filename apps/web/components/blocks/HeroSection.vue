<script setup lang="ts">
/**
 * HeroSection — главный экран по спеке hero-payload-cms-spec.md:
 * молочный фон, надзаголовок, крупный гротеск в 1–3 строки, справа описание
 * с лаймовой CTA, ниже панорамное фото с подписью и нижняя строка с разделителем.
 *
 * Все тексты, медиа и параметры оформления приходят из CMS (Pages → блок hero)
 * и применяются через CSS-переменные на корне секции. Значения ниже — те же
 * стартовые, что и в схеме блока: секция остаётся рабочей до наполнения CMS.
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
  titleLines?: { text?: string | null; id?: string }[] | null
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

interface BottomLineData {
  enabled?: boolean | null
  leftText?: string | null
  rightText?: string | null
  showDivider?: boolean | null
}

type AppearanceData = Record<string, string | number | boolean | null | undefined>

/** Нормализованные поля hero: без null/undefined — шаблон и стили работают с чистыми типами */
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

const props = defineProps<{
  hero?: HeroData | null
  bottomLine?: BottomLineData | null
  appearance?: AppearanceData | null
}>()

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

/* ---------- безопасное чтение полей со значениями по умолчанию из спеки ---------- */
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
    captionOverlayOpacity: num(h.captionOverlayOpacity, 0.15),
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

const bottomLine = computed<Required<BottomLineData>>(() => {
  const b = props.bottomLine ?? {}
  return {
    enabled: bool(b.enabled, true),
    leftText: str(b.leftText, 'Ваш объект. Новый взгляд.'),
    rightText: str(b.rightText, 'Виртуальный хоумстейджинг'),
    showDivider: bool(b.showDivider, true),
  }
})

const appearance = computed<Record<string, string | number>>(() => {
  const a = props.appearance ?? {}
  return {
    backgroundColor: str(a.backgroundColor as string, '#F8F7F3'),
    textColor: str(a.textColor as string, '#080808'),
    mutedTextColor: str(a.mutedTextColor as string, '#303030'),
    accentColor: str(a.accentColor as string, '#D7EF28'),
    accentTextColor: str(a.accentTextColor as string, '#080808'),
    dividerColor: str(a.dividerColor as string, '#B8B8B5'),
    captionColor: str(a.captionColor as string, '#FFFFFF'),
    fontFamily: str(a.fontFamily as string, 'inter'),
    titleWeight: str(a.titleWeight as string, '800'),
    titleDesktopPx: num(a.titleDesktopPx, 116),
    titleMobilePx: num(a.titleMobilePx, 48),
    titleLineHeight: num(a.titleLineHeight, 0.98),
    titleLetterSpacingEm: num(a.titleLetterSpacingEm, -0.045),
    bodyDesktopPx: num(a.bodyDesktopPx, 22),
    bodyMobilePx: num(a.bodyMobilePx, 18),
    bodyLineHeight: num(a.bodyLineHeight, 1.4),
    eyebrowPx: num(a.eyebrowPx, 12),
    eyebrowLetterSpacingEm: num(a.eyebrowLetterSpacingEm, 0.3),
    captionPx: num(a.captionPx, 14),
    bottomLinePx: num(a.bottomLinePx, 14),
    buttonTextPx: num(a.buttonTextPx, 18),
    buttonHeightPx: num(a.buttonHeightPx, 56),
    buttonPaddingXPx: num(a.buttonPaddingXPx, 28),
    buttonRadiusPx: num(a.buttonRadiusPx, 0),
    contentMaxWidthPx: num(a.contentMaxWidthPx, 1600),
    desktopGutterPx: num(a.desktopGutterPx, 48),
    mobileGutterPx: num(a.mobileGutterPx, 20),
    headerHeightPx: num(a.headerHeightPx, 88),
    heroTopPaddingPx: num(a.heroTopPaddingPx, 40),
    heroBottomPaddingPx: num(a.heroBottomPaddingPx, 36),
    heroColumnGapPx: num(a.heroColumnGapPx, 48),
    titleColumnPercent: num(a.titleColumnPercent, 68),
    descriptionButtonGapPx: num(a.descriptionButtonGapPx, 28),
    mobileStackGapPx: num(a.mobileStackGapPx, 24),
    imageWidth: str(a.imageWidth as string, 'full-bleed'),
    imageDesktopRatio: str(a.imageDesktopRatio as string, '3:1'),
    imageMobileRatio: str(a.imageMobileRatio as string, '4:3'),
    imageRadiusPx: num(a.imageRadiusPx, 0),
    captionInsetPx: num(a.captionInsetPx, 32),
    bottomLinePaddingYPx: num(a.bottomLinePaddingYPx, 24),
    dividerThicknessPx: num(a.dividerThicknessPx, 1),
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

/* ---------- оформление → CSS-переменные (§08) ---------- */
// FONT_STACKS — общий с шапкой, apps/web/utils/font-stacks.ts

const RATIO_CSS: Record<string, string> = {
  '3:1': '3 / 1',
  '16:9': '16 / 9',
  '21:9': '21 / 9',
  '4:3': '4 / 3',
  '1:1': '1 / 1',
  '3:4': '3 / 4',
}

// Размер «вписывается» в 1440px: при ширине экрана 1440 vw-часть даёт
// ровно десктопное значение, ниже — плавно к мобильной границе через clamp()
const fluidSize = (mobilePx: number, desktopPx: number) =>
  `clamp(${mobilePx}px, ${(desktopPx / 14.4).toFixed(2)}vw, ${desktopPx}px)`

const styleVars = computed(() => {
  const a = appearance.value
  const titleMobile = Number(a.titleMobilePx)
  const titleDesktop = Number(a.titleDesktopPx)
  const bodyMobile = Number(a.bodyMobilePx)
  const bodyDesktop = Number(a.bodyDesktopPx)
  const fontKey = String(a.fontFamily)
  return {
    '--h-bg': a.backgroundColor,
    '--h-text': a.textColor,
    '--h-muted': a.mutedTextColor,
    '--h-accent': a.accentColor,
    '--h-accent-text': a.accentTextColor,
    '--h-divider-color': a.dividerColor,
    '--h-caption-color': a.captionColor,
    '--h-font': FONT_STACKS[fontKey] ?? FONT_STACKS.inter,
    '--h-title-weight': a.titleWeight,
    '--h-title-size': fluidSize(titleMobile, titleDesktop),
    '--h-title-lh': String(a.titleLineHeight),
    '--h-title-ls': `${a.titleLetterSpacingEm}em`,
    '--h-body-size': fluidSize(bodyMobile, bodyDesktop),
    '--h-body-lh': String(a.bodyLineHeight),
    '--h-eyebrow-size': `${a.eyebrowPx}px`,
    '--h-eyebrow-ls': `${a.eyebrowLetterSpacingEm}em`,
    '--h-caption-size': `${a.captionPx}px`,
    '--h-bottom-size': `${a.bottomLinePx}px`,
    '--h-btn-text-size': `${a.buttonTextPx}px`,
    '--h-btn-height': `${a.buttonHeightPx}px`,
    '--h-btn-px': `${a.buttonPaddingXPx}px`,
    '--h-btn-radius': `${a.buttonRadiusPx}px`,
    '--h-max-w': `${a.contentMaxWidthPx}px`,
    '--h-gutter-d': `${a.desktopGutterPx}px`,
    '--h-gutter-m': `${a.mobileGutterPx}px`,
    '--h-header-h': `${a.headerHeightPx}px`,
    '--h-top-pad': `${a.heroTopPaddingPx}px`,
    '--h-bottom-pad': `${a.heroBottomPaddingPx}px`,
    '--h-col-gap': `${a.heroColumnGapPx}px`,
    // Доля заголовка от ширины после gap, остальное — колонка описания (§08)
    '--h-grid-cols': `${num(a.titleColumnPercent, 68)}fr ${100 - num(a.titleColumnPercent, 68)}fr`,
    '--h-desc-cta-gap': `${a.descriptionButtonGapPx}px`,
    '--h-stack-gap': `${a.mobileStackGapPx}px`,
    '--h-img-ratio-d': RATIO_CSS[String(a.imageDesktopRatio)] ?? '3 / 1',
    '--h-img-ratio-m': RATIO_CSS[String(a.imageMobileRatio)] ?? '4 / 3',
    '--h-img-radius': `${a.imageRadiusPx}px`,
    '--h-caption-inset': `${a.captionInsetPx}px`,
    '--h-bottom-pad-y': `${a.bottomLinePaddingYPx}px`,
    '--h-divider-thick': `${a.dividerThicknessPx}px`,
    '--h-shade': String(hero.value.captionOverlayOpacity),
    '--h-img-pos-d': `${hero.value.imagePositionX}% ${hero.value.imagePositionY}%`,
    '--h-img-pos-m': `${hero.value.mobileImagePositionX}% ${hero.value.mobileImagePositionY}%`,
  } as Record<string, string>
})

/* ---------- кнопка ---------- */
const ctaVisible = computed(() => cta.value.enabled && Boolean(cta.value.href))

const ctaStyle = computed(() => {
  const a = appearance.value
  switch (cta.value.variant) {
    case 'dark':
      return { backgroundColor: String(a.textColor), color: String(a.backgroundColor) }
    case 'outline':
      return { backgroundColor: 'transparent', color: String(a.textColor), border: `1px solid ${a.textColor}` }
    default:
      return { backgroundColor: String(a.accentColor), color: String(a.accentTextColor) }
  }
})

const ctaAttrs = computed(() =>
  cta.value.newTab
    ? { target: '_blank', rel: 'noopener noreferrer' }
    : {},
)
</script>

<template>
  <section class="hero" :style="styleVars">
    <!-- Надзаголовок + заголовок + описание/кнопка (§03, строки 07–11) -->
    <div class="hero-head hero-container">
      <p v-if="hero.eyebrow" class="hero-eyebrow">{{ hero.eyebrow }}</p>

      <div class="hero-grid">
        <h1 class="hero-title">
          <span v-for="(line, i) in hero.titleLines" :key="line.id ?? i" class="hero-title-line">
            {{ line.text }}
          </span>
        </h1>

        <div class="hero-aside">
          <p v-if="hero.description" class="hero-description">{{ hero.description }}</p>

          <a v-if="ctaVisible" :href="cta.href" class="hero-cta" :style="ctaStyle" v-bind="ctaAttrs">
            <span>{{ cta.label }}</span>
            <svg
              v-if="cta.icon === 'arrow-up-right'"
              class="hero-cta-arrow"
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
              class="hero-cta-arrow"
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
        </div>
      </div>
    </div>

    <!-- Панорамное изображение с подписью (§03, строки 12–13) -->
    <figure
      class="hero-figure"
      :class="{ 'hero-figure--contained': appearance.imageWidth === 'contained' }"
    >
      <picture v-if="desktopUrl">
        <source v-if="mobileUrl && mobileImage" media="(max-width: 767px)" :srcset="mobileUrl" />
        <img
          class="hero-img"
          :src="desktopUrl"
          :alt="hero.imageAlt"
          fetchpriority="high"
          decoding="async"
        />
      </picture>
      <div class="hero-shade" aria-hidden="true" />
      <figcaption v-if="hero.showImageCaption && hero.imageCaption" class="hero-caption">
        {{ hero.imageCaption }}
      </figcaption>
    </figure>

    <!-- Нижняя строка с разделителем (§03, строки 14–16) -->
    <div v-if="bottomLine.enabled" class="hero-bottom hero-container">
      <p class="hero-bottom-text">{{ bottomLine.leftText }}</p>
      <span v-if="bottomLine.showDivider" class="hero-divider" aria-hidden="true" />
      <p class="hero-bottom-text">{{ bottomLine.rightText }}</p>
    </div>
  </section>
</template>

<style scoped>
/* Значения всех переменных приходят из CMS-группы appearance (§08 спеки) */
.hero {
  --h-pad-x: var(--h-gutter-m);

  display: flex;
  flex-direction: column;
  background-color: var(--h-bg);
  color: var(--h-text);
  font-family: var(--h-font);
  /* Только горизонталь: вертикальный overflow не прячем,
     чтобы на низких окнах нижняя строка уходила в скролл, а не обрезалась */
  overflow-x: clip;
}

@media (min-width: 768px) {
  .hero {
    --h-pad-x: var(--h-gutter-d);
    /* Экран ровно без учёта шапки: фиксированная высота делает фото
       гибким наполнителем между контентом и нижней строкой.
       640px — пол: на совсем низких окнах секция скроллится */
    height: max(calc(100svh - var(--h-header-h)), 640px);
  }

  /* Композиция «в один экран»: шапка контента и нижняя строка фиксированы,
     фото растягивается/ужимается (object-fit cover компенсирует) —
     нижняя строка всегда в первом экране */
  .hero-head,
  .hero-bottom {
    flex-shrink: 0;
  }

  .hero-figure {
    flex: 1 1 auto;
    min-height: 240px;
  }
}

.hero-container {
  width: 100%;
  max-width: var(--h-max-w);
  margin-inline: auto;
  padding-inline: var(--h-pad-x);
}

/* ---------- верхняя часть ---------- */
.hero-head {
  padding-top: var(--h-top-pad);
  padding-bottom: var(--h-bottom-pad);
}

.hero-eyebrow {
  margin: 0 0 var(--h-stack-gap);
  font-size: var(--h-eyebrow-size);
  line-height: 1.3;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: var(--h-eyebrow-ls);
  color: var(--h-muted);
}

.hero-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: var(--h-stack-gap);
  align-items: end;
}

@media (min-width: 1200px) {
  .hero-grid {
    grid-template-columns: var(--h-grid-cols);
    column-gap: var(--h-col-gap);
  }
}

.hero-title {
  margin: 0;
  font-family: inherit;
  font-weight: var(--h-title-weight);
  font-size: var(--h-title-size);
  line-height: var(--h-title-lh);
  letter-spacing: var(--h-title-ls);
  color: var(--h-text);
  /* Перенос длинных слов без горизонтального скролла (§05, §12) */
  overflow-wrap: anywhere;
  hyphens: auto;
}

.hero-title-line {
  display: block;
}

.hero-aside {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: var(--h-desc-cta-gap);
}

.hero-description {
  margin: 0;
  font-size: var(--h-body-size);
  line-height: var(--h-body-lh);
  color: var(--h-muted);
}

/* ---------- кнопка (§06) ---------- */
.hero-cta {
  display: inline-flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.75rem;
  width: 100%;
  min-height: var(--h-btn-height);
  padding-inline: var(--h-btn-px);
  border-radius: var(--h-btn-radius);
  font-size: var(--h-btn-text-size);
  font-weight: 600;
  line-height: 1.2;
  text-decoration: none;
  transition: filter var(--duration-base) var(--ease-premium);
}

.hero-cta-arrow {
  width: 1.25em;
  height: 1.25em;
  flex-shrink: 0;
  transition: transform var(--duration-base) var(--ease-premium);
}

.hero-cta:hover {
  filter: brightness(0.94);
}

.hero-cta:hover .hero-cta-arrow {
  transform: translate(2px, -2px);
}

.hero-cta:focus-visible {
  outline: 2px solid var(--h-text);
  outline-offset: 2px;
}

@media (min-width: 768px) {
  .hero-cta {
    width: auto;
    justify-content: center;
  }

  .hero-cta:hover .hero-cta-arrow {
    transform: translate(3px, -3px);
  }
}

/* ---------- изображение (§05, §09) ---------- */
.hero-figure {
  position: relative;
  margin: 0;
  overflow: hidden;
  border-radius: var(--h-img-radius);
  isolation: isolate;
}

.hero-figure--contained {
  max-width: var(--h-max-w);
  margin-inline: auto;
  padding-inline: var(--h-pad-x);
  border-radius: 0;
}

.hero-img {
  display: block;
  width: 100%;
  height: 100%;
  aspect-ratio: var(--h-img-ratio-m);
  object-fit: cover;
  object-position: var(--h-img-pos-m);
}

@media (min-width: 768px) {
  .hero-img {
    aspect-ratio: var(--h-img-ratio-d);
    object-position: var(--h-img-pos-d);
  }
}

.hero-figure--contained .hero-img {
  height: auto;
}

/* Затемнение нижней части для читаемости подписи: пик — у нижней кромки */
.hero-shade {
  position: absolute;
  inset: auto 0 0;
  height: 45%;
  background: linear-gradient(
    to top,
    rgba(8, 8, 8, var(--h-shade)) 0%,
    rgba(8, 8, 8, calc(var(--h-shade) * 0.7)) 35%,
    transparent 100%
  );
  pointer-events: none;
}

.hero-caption {
  position: absolute;
  left: min(var(--h-caption-inset), var(--h-pad-x));
  bottom: min(var(--h-caption-inset), var(--h-pad-x));
  font-size: var(--h-caption-size);
  line-height: 1.3;
  letter-spacing: 0.02em;
  color: var(--h-caption-color);
}

/* ---------- нижняя строка (§07) ---------- */
.hero-bottom {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  padding-top: var(--h-bottom-pad-y);
  padding-bottom: var(--h-bottom-pad-y);
}

.hero-bottom-text {
  margin: 0;
  font-size: var(--h-bottom-size);
  line-height: 1.4;
  color: var(--h-muted);
}

.hero-divider {
  flex: 1;
  height: var(--h-divider-thick);
  background-color: var(--h-divider-color);
}

@media (max-width: 767px) {
  /* На мобильном подписи остаются колонкой, но разделитель-линия между ними
     делает композицию осознанной, а не «сломанной строкой» */
  .hero-bottom {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .hero-divider {
    display: block;
    width: 100%;
    flex: none;
  }
}
</style>
