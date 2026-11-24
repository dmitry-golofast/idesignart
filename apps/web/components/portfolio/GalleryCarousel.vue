<script setup lang="ts">
import { computed } from 'vue'
import type { Project } from '#shared/types/payload'

/**
 * PortfolioGalleryCarousel — галерея кейса на /portfolio/[slug]: все картинки
 * поля «Галерея» одним слайдером на готовом UCarousel из UI kit.
 *
 * Слайды идут в порядке CMS, тип картинки (3D-визуализация, план, реализация,
 * «до») выводится плашкой на слайде. Раньше под каждый тип была своя секция
 * с сеткой, и «план» с «до» на страницу вообще не попадали.
 *
 * Кадр: от sm все слайды одной высоты — карусель не «прыгает» при листании,
 * а картинка вписывается в кадр по высоте без обрезки (квадрат и портрет
 * уже, стоят по центру). На узких экранах слайд во всю ширину с родными
 * пропорциями, высоту подгоняет auto-height.
 */
const props = defineProps<{
  gallery: Project['gallery']
  /** alt для картинки, у которой нет ни caption, ни alt в медиатеке */
  title?: string
}>()

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

const typeLabels: Record<string, string> = {
  before: 'До',
  after: 'Реализация',
  render: '3D-визуализация',
  plan: 'План',
}

// Пропорция кадра от sm и предел его высоты — те же, что в классах
// sm:aspect-[3/2] и sm:max-h-[…] на кадре ниже
const FRAME_RATIO = 3 / 2
const FRAME_MAX_WIDTH = 1080

const slides = computed(() =>
  (props.gallery ?? []).flatMap((g) => {
    const media = populated(g.image)
    // Картинка с оборвавшейся связью в слайдер не попадает
    if (!media?.url) return []
    return [{
      src: media.url.startsWith('http') ? media.url : `${payloadBase}${media.url}`,
      alt: g.caption || media.alt || props.title || '',
      caption: g.caption || '',
      typeLabel: g.type ? typeLabels[g.type] : '',
      ratio: media.width && media.height ? media.width / media.height : FRAME_RATIO,
    }]
  }),
)

const isCarousel = computed(() => slides.value.length > 1)

/**
 * sizes для NuxtImg — только префиксный синтаксис nuxt/image: CSS-строки
 * вида «(min-width: …)» он не парсит и собирает srcset из картинок 1px/2px.
 *
 * В кадре картинка занимает долю ширины слайда: альбомная — весь слайд,
 * квадрат — две трети, портрет — ещё уже. Слайд — это колонка контента
 * страницы кейса: до lg (одна колонка) 92vw, на lg+ 92vw − 384px (сайдбар
 * с отступом), но не шире FRAME_MAX_WIDTH.
 */
function slideSizes(ratio: number) {
  const share = Math.min(1, ratio / FRAME_RATIO)
  const slot = (shareOfViewport: number) => Math.round(shareOfViewport * share)
  return `sm:${slot(92)}vw lg:${slot(62)}vw xl:${slot(68)}vw 2xl:${Math.round(FRAME_MAX_WIDTH * share)}px 100vw`
}

// Стрелки крупнее дефолтных 32px UI kit: 40px от sm, 48px от lg (иконка 24px).
// Размер — отступами вокруг иконки, как в самом UI kit: с явным size и p-0
// иконка прилипает к левому краю кружка
const arrowButton = {
  size: 'lg' as const,
  class: 'sm:p-2.5 lg:p-3',
  ui: { leadingIcon: 'lg:size-6' },
}

const carouselUi = {
  arrows: 'hidden sm:flex',
  // Стрелки — поверх краёв кадра: дефолт UI kit на sm выносит их на 48px
  // за края карусели, а в колонке контента там сайдбар. Держим их на
  // середине кадра, а не слайда — под кадром строка подписи (16px + 24px)
  prev: 'sm:start-4 sm:top-[calc(50%-20px)]',
  next: 'sm:end-4 sm:top-[calc(50%-20px)]',
  // Точки — по центру под подписью (позиция UI kit по умолчанию)
  dot: 'bg-[var(--color-line)] data-[state=active]:bg-[var(--color-ink)]',
  // auto-height меняет высоту контейнера — на узких экранах (там слайды
  // разной высоты) она меняется плавно
  container: 'transition-[height] duration-300 sm:transition-none',
}
</script>

<template>
  <section v-if="slides.length">
    <h2 class="content-heading">Галерея</h2>

    <!-- В карусели оставляем место под точки: UI kit выносит их на 28px за
         нижний край слайда — своей строкой по центру под подписью -->
    <div class="mt-6" :class="isCarousel ? 'pb-10' : ''">
      <UCarousel
        v-slot="{ item }"
        :items="slides"
        align="start"
        :loop="isCarousel"
        auto-height
        :arrows="isCarousel"
        :dots="isCarousel"
        :prev="arrowButton"
        :next="arrowButton"
        aria-label="Галерея проекта"
        :ui="carouselUi"
      >
        <figure>
          <!-- Кадр: от sm — стабильная высота на все слайды. mx-auto — когда
               высота упирается в предел, кадр по aspect-ratio сужается;
               без этого он прижимается влево -->
          <div class="sm:aspect-[3/2] sm:max-h-[min(70vh,720px)] sm:grid sm:place-items-center sm:mx-auto">
            <!-- Картинка: во всю ширину слайда со своими пропорциями, от sm —
                 вписана в кадр по высоте (grid + place-items-center) и по
                 центру; абс. позиционирование здесь не годится — Chrome
                 растягивает такой бокс на всю ширину кадра -->
            <div
              class="relative w-full overflow-hidden rounded-[var(--radius-lg)] border border-[var(--color-line)] bg-[var(--color-surface-alt)] sm:h-full sm:max-w-full sm:w-auto"
              :style="{ aspectRatio: item.ratio }"
            >
              <NuxtImg
                :src="item.src"
                :alt="item.alt"
                :sizes="slideSizes(item.ratio)"
                format="webp,avif"
                class="absolute inset-0 h-full w-full object-cover"
              />
              <!-- Плашка типа — тот же крем-чип, что на карточке проекта -->
              <span
                v-if="item.typeLabel"
                class="absolute top-4 left-4 rounded-[var(--radius-pill)] bg-[#fdfaf3]/92 px-3.5 py-1.5 text-[11px] font-medium tracking-[0.08em] text-[var(--color-ink)] uppercase backdrop-blur-sm"
              >
                {{ item.typeLabel }}
              </span>
            </div>
          </div>
          <!-- Подпись. В карусели строка одной высоты у всех слайдов — высота
               карусели не меняется при листании -->
          <figcaption
            class="mt-4 text-base text-[var(--color-ink-muted)]"
            :class="isCarousel ? 'sm:min-h-6 sm:truncate' : ''"
          >
            {{ item.caption }}
          </figcaption>
        </figure>
      </UCarousel>
    </div>
  </section>
</template>
