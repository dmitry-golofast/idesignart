<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import type { Media, Service } from '#shared/types/payload'

/**
 * ServicesGrid — блок «Чем мы можем помочь» (редизайн v6, «соты-контур»).
 *
 * Фон блока — изображение во всю секцию: рисунок читается слева
 * (object-position: left), правую половину успокаивает кремовая вуаль.
 * При появлении блока фон показывает секвенцию «чертёж → рендер»:
 * первым проявляется ч/б чертёж (статичный ассет bg-sketch.webp),
 * поверх него крестфейдом «прорисовывается» цветной рендер финальной
 * сцены (статичный ассет bg-render.webp)
 * с лёгким наездом камеры. Весь контент — 10 одинаковых шестигранников-сот
 * (ряды 4/3/3), они занимают всю правую сторону (размер ячейки считается
 * от высоты вьюпорта); каждый ряд сдвинут на пол-ячейки правее предыдущего —
 * слева получается «лестница» пчелиных сот. Рамка соты — pointy-top
 * по референсу gex.svg (полигон 448×512, stroke #696852, 3px, miter).
 * Внутри соты — фото услуги (клип по форме соты), градиент под текст,
 * tagline и название. Появление сот — по очереди в случайном порядке
 * с базовой задержкой (после «прорисовки» рендера): чистый fade без
 * смещения («на своих местах»); задержки перемешиваются на клиенте
 * после монтирования, чтобы не ловить hydration mismatch.
 *
 * Данные: услуги из Payload через useServices() либо через props.
 */
// inheritAttrs: false — в старых данных CRM-страниц может остаться поле
// description; компонент от него больше не зависит и не рендерит его.
defineOptions({ inheritAttrs: false })

const props = defineProps<{
  services?: Service[]
  title?: string
  /** Фоновое изображение блока; по умолчанию — cardImage первой услуги */
  bgImage?: number | Media | null
  /** Номер главы — присваивается по порядку блоков на странице (PageSections) */
  num?: number
}>()

const payloadBase = useRuntimeConfig().public.payloadApiUrl as string

const secNum = computed(() => String(props.num ?? 1).padStart(2, '0'))

// Если услуги не переданы — тянем опубликованные featured.
// cardImage/bgImage — связь Payload (number | Media), сужаем до объекта.
const { data } = useServices({ featuredOnly: !props.services?.length })
const services = computed(() =>
  (props.services?.length ? props.services : (data.value?.docs || []))
    .map((s) => ({ ...s, cardImage: populated(s.cardImage) })),
)

/* ---------- раскладка сот: ряды 4 / 3 / 3 = 10 ячеек ---------- */
const ROW_SIZES = [4, 3]
const MAX_ROWS = 3

const honeyCells = computed(() => {
  const rows: { svcIdx: number; i: number }[][] = []
  let start = 0
  let k = 0 // плоский индекс ячейки — для каскадных задержек
  for (let ri = 0; ri < MAX_ROWS && start < services.value.length; ri++) {
    const size = ROW_SIZES[ri % ROW_SIZES.length]
    const row = services.value
      .slice(start, start + size)
      .map((_, ci) => ({ svcIdx: start + ci, i: k++ }))
    rows.push(row)
    start += size
  }
  return rows
})

/* Случайный порядок появления: перемешиваем задержки на клиенте
   после монтирования (Math.random на SSR сломал бы гидратацию).
   Базовая задержка — соты начинаю проявляться, когда фон уже
   «прорисовался» (ч/б чертёж → цветной рендер) */
const HEX_BASE_DELAY = 1900

const hexDelays = ref<number[]>([])
onMounted(() => {
  const total = honeyCells.value.reduce((acc, row) => acc + row.length, 0)
  const delays = Array.from({ length: total }, (_, i) => HEX_BASE_DELAY + i * 160)
  for (let i = delays.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[delays[i], delays[j]] = [delays[j], delays[i]]
  }
  hexDelays.value = delays
})

const hexStyle = (i: number) => ({
  '--hex-delay': `${hexDelays.value[i] ?? HEX_BASE_DELAY + i * 120}ms`,
})

/* Диагональная укладка: каждый ряд на пол-ячейки правее предыдущего */
const rowStyle = (ri: number) => ({
  '--row-shift': `calc((var(--hx) + var(--hexgap)) * ${ri} / 2)`,
})

function imageUrl(media: { url?: string } | null | undefined): string | null {
  const url = media?.url
  if (!url) return null
  return url.startsWith('http') ? url : `${payloadBase}${url}`
}
</script>

<template>
  <section class="svc-full">
    <!-- Фон-изображение: рисунок прижат к левому краю, справа — вуаль.
         Секвенция при появлении блока: сначала ч/б чертёж, затем цветной
         рендер «прорисовывается» крестфейдом (статичная пара ассетов
         bg-sketch.webp + bg-render.webp одной сцены), после —
         проявляются соты (базовая задержка в hexDelays) -->
    <div class="svc-bg" aria-hidden="true" data-reveal="fade">
      <img
        src="/images/services/bg-sketch.webp"
        alt=""
        class="svc-bg-img svc-bg-sketch"
        loading="lazy"
        decoding="async"
      />
      <img
        src="/images/services/bg-render.webp"
        alt=""
        class="svc-bg-img svc-bg-photo"
        loading="lazy"
        decoding="async"
      />
      <span class="svc-bg-shade" />
    </div>

    <div class="container-app svc-inner">
      <!-- Editorial-шапка: номер главы + заголовок (над рисунком слева) -->
      <div class="sec-head" data-reveal>
        <span class="sec-num" aria-hidden="true">{{ secNum }}</span>
        <h2 class="sec-title">{{ title || 'Чем мы можем помочь' }}</h2>
      </div>

      <!-- Справа: 10 сот «лестницей», весь контент — в них -->
      <div class="svc-honey" data-reveal="fade">
        <div
          v-for="(row, ri) in honeyCells"
          :key="ri"
          class="honey-row"
          :style="rowStyle(ri)"
        >
          <NuxtLink
            v-for="cell in row"
            :key="cell.i"
            :to="`/services/${services[cell.svcIdx]!.slug}`"
            :aria-label="`Подробнее: ${services[cell.svcIdx]!.title}`"
            class="svc-hex"
            :class="{ 'svc-hex--plain': !imageUrl(services[cell.svcIdx]!.cardImage) }"
            :style="hexStyle(cell.i)"
          >
            <!-- Фото услуги, клип по форме соты; градиент — под текст -->
            <span class="svc-hex-media" aria-hidden="true">
              <NuxtImg
                v-if="imageUrl(services[cell.svcIdx]!.cardImage)"
                :src="imageUrl(services[cell.svcIdx]!.cardImage)!"
                :alt="services[cell.svcIdx]!.cardImage?.alt || services[cell.svcIdx]!.title"
                sizes="sm:30vw lg:14vw"
                format="webp,avif"
                class="svc-hex-img"
                loading="lazy"
              />
              <span class="svc-hex-shade" />
            </span>

            <!-- Рамка соты: референс gex.svg (448×512, stroke #696852, 3px) -->
            <svg class="svc-hex-frame" viewBox="0 0 448 512" aria-hidden="true" focusable="false">
              <polygon
                points="224,8 438.7743,132 438.7743,380 224,504 9.2257,380 9.2257,132"
                vector-effect="non-scaling-stroke"
              />
            </svg>

            <span class="svc-hex-body">
              <span v-if="services[cell.svcIdx]!.tagline" class="svc-hex-tagline">
                {{ services[cell.svcIdx]!.tagline }}
              </span>
              <span class="svc-hex-title">{{ services[cell.svcIdx]!.title }}</span>
            </span>
          </NuxtLink>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* =========================================================
 * «Чем мы можем помочь» v6 — фон с рисунком слева, справа
 * 8 сот с фото и текстом, рамка-контур по референсу gex.svg
 * ========================================================= */

/* Ровно первый экран: вьюпорт минус sticky-шапка (--hd-height на <html>).
   Фолбэки: vh для старых браузеров → svh → dvh. Высота жёсткая: соты,
   не влезающие по вертикали, слегка обрезаются нижней границей секции
   (overflow: hidden) — блок не растягивает страницу */
.svc-full {
  position: relative;
  display: flex;
  flex-direction: column;
  height: calc(100vh - var(--hd-height, 76px));
  height: calc(100svh - var(--hd-height, 76px));
  height: calc(100dvh - var(--hd-height, 76px));
  padding-top: clamp(1.5rem, 4vh, 3rem);
  padding-bottom: clamp(1.25rem, 3vh, 2.5rem);
  overflow: hidden;
  background-color: var(--color-canvas);
}

/* ---------- фон: изображение с рисунком слева ---------- */
.svc-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
  isolation: isolate;
}

/* Слои фона друг на друге (абсолютные): снизу ч/б чертёж, сверху рендер */
.svc-bg-img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: left center;
}

/* Секвенция фона: ч/б чертёж виден сразу (нижний слой), цветной рендер
   «прорисовывается» поверх него крестфейдом с лёгким наездом камеры —
   как рендер кадра. Без JS (нет .has-js) сразу виден рендер;
   при prefers-reduced-motion глобальное правило гасит длительность,
   здесь дополнительно снимаем задержку */
.has-js .svc-bg-photo {
  opacity: 0;
  transform: scale(1.035);
  transition:
    opacity 1.4s var(--ease-premium) 1.15s,
    transform 1.7s var(--ease-premium) 1.15s;
}

.has-js .svc-bg.is-revealed .svc-bg-photo {
  opacity: 1;
  transform: none;
}

@media (prefers-reduced-motion: reduce) {
  .has-js .svc-bg-photo {
    transition-delay: 0ms;
  }
}

/* Вуаль: справа кремовая подложка под соты, сверху — лёгкая смывка
   под editorial-заголовок; левая треть остаётся чистым рисунком */
.svc-bg-shade {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(
      to left,
      rgba(246, 241, 231, 0.95) 0%,
      rgba(246, 241, 231, 0.6) 34%,
      rgba(246, 241, 231, 0) 62%
    ),
    linear-gradient(
      to bottom,
      rgba(246, 241, 231, 0.6) 0%,
      rgba(246, 241, 231, 0) 32%
    );
}

.svc-inner {
  position: relative;
  z-index: 1;
  flex: 1 1 auto;
  /* min-height: 0 — позволяет сотам сжаться до слота и обрезаться
     нижней границей секции, а не распирать её */
  min-height: 0;
  display: flex;
  flex-direction: column;
}

/* ---------- справа: соты на всю правую сторону ----------
   Блок увеличен ×1.3: соты намеренно выходят за правый и нижний
   края и частично обрезаются секцией (overflow: hidden у .svc-full).
   Верх прижат к слоту под заголовком (justify-content: flex-start):
   соты не поднимаются выше hairline-линии под «Чем мы можем помочь» */
.svc-honey {
  --hexgap: clamp(6px, 0.6vw, 10px);
  --hx: calc(
    clamp(8.5rem, min(14vw, calc((100svh - 280px) / 2.9)), 16.5rem) * 1.3
  );
  --hh: calc(var(--hx) * 512 / 448); /* высота по референсу gex.svg */
  flex: 1 1 auto;
  /* Позволяем контейнеру сжаться до слота: ряды перельются за нижний
     край и обрежутся секцией, а не растянут её */
  min-height: 0;
  margin-left: auto; /* кластер прижат к правой половине блока */
  margin-top: clamp(1rem, 2.5vh, 2rem);
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: flex-start;
  width: fit-content;
}

.honey-row {
  display: flex;
  gap: var(--hexgap);
  /* Диагональная укладка сот: ряд стартует на пол-ячейки правее
     предыдущего — слева получается «лестница» (см. --row-shift) */
  transform: translateX(var(--row-shift, 0px));
}

.honey-row + .honey-row {
  /* Укладка сот: ряд заходит на предыдущий на четверть высоты */
  margin-top: calc(var(--hh) * -0.25 + var(--hexgap));
}

/* Шестигранник: pointy-top по референсу gex.svg.
   Рамка — inline-SVG (клип не даёт обводки), фото и текст поверх */
.svc-hex {
  position: relative;
  width: var(--hx);
  height: var(--hh);
  flex: none;
  display: block;
  color: #fdfaf3;
}

/* Фото услуги, клип по вершинам полигона gex.svg (в % от 448×512) */
.svc-hex-media {
  position: absolute;
  inset: 0;
  display: block;
  clip-path: polygon(
    50% 1.7%,
    97.7% 25.9%,
    97.7% 74.1%,
    50% 98.3%,
    2.3% 74.1%,
    2.3% 25.9%
  );
  background-color: var(--color-surface-alt);
  overflow: hidden;
}

.svc-hex-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.7s var(--ease-premium);
}

a.svc-hex:hover .svc-hex-img {
  transform: scale(1.06);
}

/* Градиент: тёплый тёмный тон по всей соте — читаемость текста
   в центре (полоса tagline + title, ~40–70% высоты), чуть плотнее
   к нижней вершине */
.svc-hex-shade {
  position: absolute;
  inset: 0;
  background: linear-gradient(
    to top,
    rgba(24, 18, 13, 0.8) 0%,
    rgba(24, 18, 13, 0.5) 55%,
    rgba(24, 18, 13, 0.24) 100%
  );
}

/* Сота без фото: кремовая заливка, тёмный текст */
.svc-hex--plain .svc-hex-media {
  background-color: rgba(253, 250, 243, 0.92);
}

.svc-hex--plain .svc-hex-shade {
  display: none;
}

.svc-hex--plain {
  color: var(--color-ink);
}

.svc-hex-frame {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  display: block;
  overflow: visible;
  pointer-events: none;
}

.svc-hex-frame polygon {
  fill: transparent;
  stroke: #696852;
  stroke-width: 3;
  stroke-linejoin: miter;
}

.svc-hex-body {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  gap: 0.25rem;
  /* pointy-top: контент живёт в широкой средней полосе соты,
     у острых вершин сверху/снизу остаются пустые поля */
  padding: 26% 12%;
}

.svc-hex-tagline {
  font-size: 0.5625rem;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  opacity: 0.92;
  /* Тень обязательна: tagline — самый мелкий текст соты, на светлых
     рендерах без неё пропадает (у title тень была изначально) */
  text-shadow: 0 1px 10px rgba(24, 18, 13, 0.6);
}

.svc-hex-title {
  font-size: clamp(0.8125rem, 0.95vw, 1.0625rem);
  line-height: 1.2;
  font-weight: 700;
  letter-spacing: -0.01em;
  overflow-wrap: anywhere;
  hyphens: auto;
  text-shadow: 0 1px 12px rgba(24, 18, 13, 0.45);
}

/* ---------- появление сот: плавный fade по очереди ----------
   Контейнер (.svc-honey) получает .is-revealed от reveal-системы
   при прокрутке до блока; каждый шестигранник проявляется со своей
   случайной задержкой --hex-delay. Без смещения — строго «на своих
   местах». Без JS соты видны сразу */
.has-js .svc-hex {
  opacity: 0;
  transition: opacity 0.7s var(--ease-premium);
  transition-delay: var(--hex-delay, 0ms);
}

.has-js .svc-honey.is-revealed .svc-hex {
  opacity: 1;
}

@media (prefers-reduced-motion: reduce) {
  .has-js .svc-hex {
    transition: none;
    transition-delay: 0ms;
  }
}

/* ---------- мобильный: соты по центру, крупнее ----------
   Верхний ряд — 4 соты: 28vw × 4 не помещаются в контейнер
   намеренно — крайние соты обрезаются краями экрана */
@media (max-width: 1023px) {
  .svc-honey {
    margin-inline: auto;
    --hx: calc(clamp(5rem, 21.5vw, 8rem) * 1.3);
  }

  .svc-hex-body {
    padding: 22% 9%;
  }
}

/* На очень узких экранах tagline не помещается в маленькую соту */
@media (max-width: 479px) {
  .svc-hex-tagline {
    display: none;
  }

  .svc-hex-body {
    padding: 22% 5%;
  }

  .svc-hex-title {
    font-size: 0.55rem;
  }
}
</style>
