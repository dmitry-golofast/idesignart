<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import type { Category, Project } from '#shared/types/payload'

/**
 * PortfolioShowcase — блок «Наши работы» (редизайн v4, витрина-карусель).
 *
 * Полноэкранная тёмная секция (фирменный эспрессо + зерно и тёплое свечение),
 * в центре сцены — обложка текущего проекта, слева поверх — панель с описанием:
 * счётчик «01 / 06», категория, крупный заголовок, локация, excerpt и ссылка
 * «Смотреть проект». Параллакс при прокрутке (CSS-переменные обновляются
 * на скролле, без keyframe-анимаций): фото в рамке статично, глубину
 * дают только каменные кубы с гравировкой «i» (public/images/cubes,
 * фирменный знак студии) — они отстают от прокрутки: пока блок въезжает
 * на экран, кубы ниже своих мест, когда блок полностью разместился —
 * стоят на 100px ниже базовых позиций, дальше уплывают вверх.
 *
 * Проекты сменяются по клику (стрелки, миниатюры, клик по обложке или
 * по категории в нижней строке) с эффектом: верхний слой с новой обложкой
 * открывается шторкой (clip-path по направлению навигации) поверх нижнего
 * слоя с предыдущей; текст панели перезапускает каскад. Смена слоёв не
 * использует Vue-Transition — ключ перезапускает CSS-анимацию, ничего
 * не зависит от leave-хуков. Клавиши ← / → работают, когда фокус внутри секции.
 *
 * Данные: проекты из Payload (ручной выбор в админке либо featured),
 * категории типа «Проект» — навигация в нижней строке.
 */
defineOptions({ inheritAttrs: false })

const props = defineProps<{
  projects?: (Project | number)[] | null
  title?: string
  limit?: number
  /** Номер главы — присваивается по порядку блоков на странице (PageSections) */
  num?: number
}>()

const payloadBase = useRuntimeConfig().public.payloadApiUrl as string
const secNum = computed(() => String(props.num ?? 1).padStart(2, '0'))

/* ---------- проекты: ручной выбор из CMS либо featured ---------- */
const manualProjects = computed(() =>
  (props.projects ?? []).filter((p): p is Project =>
    Boolean(p) && typeof p === 'object' && 'slug' in p,
  ),
)

const { data } = useProjects({ featured: manualProjects.value.length === 0, limit: props.limit || 6 })
const projects = computed(() =>
  manualProjects.value.length ? manualProjects.value : (data.value?.docs || []),
)

/* ---------- карусель ---------- */
const active = ref(0)
const direction = ref<1 | -1>(1)

/* Предыдущий проект остаётся нижним слоем сцены: верхний (текущий)
   открывается шторкой поверх него. Смена не зависит от leave-транзишнов
   Vue — ключ перезапускает CSS-анимацию, слои меняются мгновенно */
const previous = ref<Project | null>(null)

const current = computed(() => projects.value[active.value])
const total = computed(() => projects.value.length)

function go(i: number, dir?: 1 | -1) {
  if (total.value === 0) return
  const target = ((i % total.value) + total.value) % total.value
  if (target !== active.value) {
    previous.value = current.value ?? previous.value
    direction.value = dir ?? (target > active.value ? 1 : -1)
  }
  active.value = target
}
const next = () => go(active.value + 1, 1)
const prev = () => go(active.value - 1, -1)

const pad = (n: number) => String(n).padStart(2, '0')

/* ---------- категории типа «Проект» — нижняя строка ---------- */
const { data: categoriesData } = usePayload<{ docs: Category[] }>('categories', {
  where: payloadWhere({ type: { equals: 'project' } }),
  limit: '20',
  sort: 'order',
})
const categories = computed(() =>
  categoriesData.value?.docs ?? [],
)

/** Проекты текущей категории в загруженной выборке */
const projectSlugsOf = (slug: string) =>
  projects.value.filter(p =>
    (p.categories ?? []).some(c => typeof c === 'object' && c !== null && c.slug === slug),
  )

const activeCategorySlug = computed(() => {
  const cats = (current.value?.categories ?? []).filter(
    (c): c is Category => Boolean(c) && typeof c === 'object',
  )
  return cats[0]?.slug ?? null
})

function jumpToCategory(slug: string) {
  const i = projects.value.findIndex(p =>
    (p.categories ?? []).some(c => typeof c === 'object' && c !== null && c.slug === slug),
  )
  if (i >= 0) go(i)
}

/* ---------- медиа ---------- */
const populatedCover = (p?: Project | null) =>
  p && p.coverImage && typeof p.coverImage === 'object' ? p.coverImage : null

const absUrl = (url?: string | null) =>
  url ? (url.startsWith('http') ? url : `${payloadBase}${url}`) : ''

const coverUrl = (p?: Project | null) => absUrl(populatedCover(p)?.url)
const coverAlt = (p?: Project | null) => populatedCover(p)?.alt || p?.title || ''

/** Плашка типа объекта: категория проекта, при отсутствии — тип из meta */
const propertyLabels: Record<string, string> = {
  apartment: 'Квартира',
  house: 'Частный дом',
  office: 'Офис',
  retail: 'Ритейл',
  hospitality: 'HoReCa',
  other: 'Другой объект',
}
const badge = computed(() => {
  const cats = (current.value?.categories ?? []).filter(
    (c): c is Category => Boolean(c) && typeof c === 'object',
  )
  if (cats[0]?.title) return cats[0].title
  const pt = current.value?.meta?.propertyType
  return pt ? propertyLabels[pt] : null
})

/** Строка метаданных: локация · площадь · год */
const metaLine = computed(() => {
  const m = current.value?.meta
  return [m?.location, m?.area ? `${m.area} м²` : null, m?.year ? String(m.year) : null]
    .filter(Boolean)
    .join(' · ')
})

/* Каменные кубы (фирменный знак «i»): позиции и размеры — в CSS-классах,
   speed — коэффициент параллакса (px сдвига на единицу --cs, усилен ×3).
   Кубы отстают от скролла: пока блок въезжает на экран, они сидят ниже
   базовой точки, при полном размещении блока встают ровно на свои
   места (позиции как на референсе), при прокрутке дальше — уплывают вверх */
const CUBES = [
  { src: '/images/cubes/cube-top.webp', cls: 'cube-a', speed: 540 },
  { src: '/images/cubes/cube-front.webp', cls: 'cube-b', speed: 342 },
  { src: '/images/cubes/cube-right.webp', cls: 'cube-c', speed: 228 },
  { src: '/images/cubes/cube-top.webp', cls: 'cube-d', speed: 627 },
  { src: '/images/cubes/cube-front.webp', cls: 'cube-e', speed: 258 },
]

/* ---------- параллакс кубов при прокрутке блока ---------- */
const sectionEl = ref<HTMLElement | null>(null)

/** Прогресс прокрутки блока: 0 — блок вошёл снизу, 1 — полностью ушёл вверх */
const progress = ref(0)

/** Отставание кубов от скролла: 0 — блок встал на экран (базовые позиции),
 *  положительное — блок ещё въезжает, кубы ниже своих мест,
 *  отрицательное — блок уходит, кубы уплывают вверх */
const cubeShift = ref(0)

/* Считаем прямо в обработчике: один getBoundingClientRect на событие,
   без rAF-очереди — смена не должна зависеть от планировщика кадров */
function updateProgress() {
  const el = sectionEl.value
  if (!el) return
  const rect = el.getBoundingClientRect()
  const vh = window.innerHeight
  if (rect.top > vh * 1.5 || rect.bottom < -vh * 0.5) return // блок далеко — не тратимся
  const hd = parseFloat(
    getComputedStyle(document.documentElement).getPropertyValue('--hd-height'),
  )
  const headerH = Number.isFinite(hd) ? hd : 76
  // Точка «блок полностью на экране»: верх секции упёрся в sticky-шапку
  const settleP = (vh - headerH) / (vh + rect.height)
  const p = (vh - rect.top) / (vh + rect.height)
  progress.value = Math.min(1, Math.max(0, p))
  cubeShift.value = settleP - p
}

onMounted(() => {
  // Reduced motion: кубы статичны, параллакс не включаем
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
  window.addEventListener('scroll', updateProgress, { passive: true })
  window.addEventListener('resize', updateProgress, { passive: true })
  updateProgress()
})

onBeforeUnmount(() => {
  window.removeEventListener('scroll', updateProgress)
  window.removeEventListener('resize', updateProgress)
})
</script>

<template>
  <section
    ref="sectionEl"
    class="showcase"
    aria-roledescription="карусель"
    :aria-label="title || 'Наши работы'"
    :style="{ '--p': progress.toFixed(3), '--cs': cubeShift.toFixed(3) }"
    @keydown.left.prevent="prev"
    @keydown.right.prevent="next"
  >
    <!-- Фирменный фон: тёплое свечение за сценой + зерно (псевдоэлементы) -->

    <!-- Каменные кубы (задний план) — появляются после сцены, уходят
         параллаксом при прокрутке, клики не перехватывают -->
    <div class="cubes" data-reveal="fade" style="--reveal-delay: 500ms" aria-hidden="true">
      <img
        v-for="c in CUBES"
        :key="c.cls"
        :src="c.src"
        :width="560"
        :height="560"
        alt=""
        class="cube"
        :class="c.cls"
        :style="{ '--cs-speed': c.speed }"
        loading="lazy"
        decoding="async"
        draggable="false"
      />
    </div>

    <!-- Editorial-шапка главы: номер + название + hairline -->
    <header class="sec-head" data-reveal>
      <span class="sec-num" aria-hidden="true">{{ secNum }}</span>
      <h2 class="sec-title">{{ title || 'Наши работы' }}</h2>
    </header>

    <!-- Сцена: обложка проекта + панель описания -->
    <div v-if="total && current" class="stage" data-reveal="zoom">
      <div class="frame" :data-dir="direction === -1 ? 'prev' : 'next'">
        <!-- Нижний слой — предыдущий проект (под шторкой верхнего) -->
        <div v-if="previous" class="work-layer" aria-hidden="true">
          <NuxtImg
            v-if="coverUrl(previous)"
            :src="coverUrl(previous)"
            :alt="''"
            sizes="lg:78vw 100vw"
            format="webp,avif"
            loading="lazy"
            decoding="async"
            class="work-img"
          />
        </div>

        <!-- Верхний слой — текущий проект: keyed-ключ перезапускает шторку -->
        <div :key="current.id" class="work-layer work-top">
          <NuxtImg
            v-if="coverUrl(current)"
            :src="coverUrl(current)"
            :alt="coverAlt(current)"
            sizes="lg:78vw 100vw"
            format="webp,avif"
            loading="eager"
            decoding="async"
            class="work-img"
          />
        </div>

        <!-- Кликовая зона поверх обложки: смена на следующий проект -->
        <button
          v-if="total > 1"
          type="button"
          class="stage-hit"
          aria-label="Показать следующий проект"
          @click="next"
        />

        <!-- Панель описания: keyed-ключ перезапускает каскад появления -->
        <div :key="current.id" class="panel">
            <p class="panel-idx panel-item" style="--pi: 0" aria-hidden="true">
              {{ pad(active + 1) }} <span>/</span> {{ pad(total) }}
            </p>

            <div class="panel-main" aria-live="polite">
              <p v-if="badge" class="panel-badge panel-item" style="--pi: 1">{{ badge }}</p>
              <h3 class="panel-title panel-item" style="--pi: 2">{{ current.title }}</h3>
              <p v-if="metaLine" class="panel-meta panel-item" style="--pi: 3">{{ metaLine }}</p>
              <p v-if="current.excerpt" class="panel-desc panel-item" style="--pi: 4">
                {{ current.excerpt }}
              </p>

              <NuxtLink
                :to="`/portfolio/${current.slug}`"
                class="panel-link panel-item"
                style="--pi: 5"
                :aria-label="`Открыть проект ${current.title}`"
              >
                <span class="panel-link-orb" aria-hidden="true">
                  <UIcon name="i-lucide-arrow-right" class="h-4.5 w-4.5" />
                </span>
                <span class="panel-link-label">Смотреть проект</span>
              </NuxtLink>
            </div>
          </div>
      </div>
    </div>

    <!-- Пустая выборка -->
    <div v-else class="stage-empty" data-reveal>
      <p>Проекты скоро появятся в этом разделе.</p>
      <NuxtLink to="/portfolio" class="panel-link mt-6">
        <span class="panel-link-orb" aria-hidden="true">
          <UIcon name="i-lucide-arrow-right" class="h-4.5 w-4.5" />
        </span>
        <span class="panel-link-label">Все проекты</span>
      </NuxtLink>
    </div>

    <!-- Управление: миниатюры + стрелки -->
    <div v-if="total > 1" class="controls" data-reveal="fade" style="--reveal-delay: 150ms">
      <div class="thumbs" role="group" aria-label="Миниатюры проектов">
        <button
          v-for="(p, i) in projects"
          :key="p.id"
          type="button"
          class="thumb"
          :class="{ 'is-active': i === active }"
          :aria-label="`Показать проект ${p.title}`"
          :aria-current="i === active"
          @click="go(i)"
        >
          <NuxtImg
            v-if="coverUrl(p)"
            :src="coverUrl(p)"
            :alt="''"
            sizes="96px"
            format="webp"
            loading="lazy"
            decoding="async"
          />
        </button>
      </div>

      <div class="nav">
        <button type="button" class="nav-btn" aria-label="Предыдущий проект" @click="prev">
          <UIcon name="i-lucide-chevron-left" class="h-5 w-5" />
        </button>
        <button type="button" class="nav-btn" aria-label="Следующий проект" @click="next">
          <UIcon name="i-lucide-chevron-right" class="h-5 w-5" />
        </button>
      </div>
    </div>

    <!-- Нижняя строка: категории-фильтры слева, тэглайн справа -->
    <footer class="show-foot" data-reveal="fade" style="--reveal-delay: 250ms">
      <ul v-if="categories.length" class="foot-cats" aria-label="Типы проектов">
        <li v-for="c in categories" :key="c.id">
          <button
            type="button"
            class="foot-cat"
            :class="{ 'is-active': activeCategorySlug === c.slug }"
            :disabled="projectSlugsOf(c.slug).length === 0"
            @click="jumpToCategory(c.slug)"
          >
            {{ c.title }}
          </button>
        </li>
      </ul>
      <p class="foot-tagline">Интерьеры, в которых хочется жить.</p>
    </footer>
  </section>
</template>

<style scoped>
/* =========================================================
 * Секция: весь вьюпорт, тёмный эспрессо в фирменном стиле.
 * ========================================================= */
.showcase {
  position: relative;
  display: flex;
  flex-direction: column;
  /* Минус sticky-шапка: при переходе по якорю блок целиком виден под ней
     (--hd-height задаёт AppHeader на <html>, как в hero) */
  min-height: calc(100vh - var(--hd-height, 76px));
  min-height: calc(100svh - var(--hd-height, 76px));
  min-height: calc(100dvh - var(--hd-height, 76px));
  padding-top: calc(76px + clamp(1.25rem, 3vh, 2.5rem));
  padding-bottom: clamp(1.25rem, 2.5vh, 2rem);
  padding-inline: var(--container-pad);
  overflow: hidden;
  background: linear-gradient(180deg, #2b221a 0%, var(--color-espresso) 52%, #1d1610 100%);
  color: #f6f1e7;
  font-family: var(--font-display);
}

/* Тёплое свечение за сценой */
.showcase::before {
  content: "";
  position: absolute;
  inset: 0;
  z-index: 0;
  background: radial-gradient(58% 62% at 50% 46%, rgba(246, 241, 231, 0.07), transparent 72%);
  pointer-events: none;
}

/* Зерно — фирменная «плёночная» текстура поверх всего блока */
.showcase::after {
  content: "";
  position: absolute;
  inset: 0;
  z-index: 50;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='160' height='160'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='160' height='160' filter='url(%23n)' opacity='0.5'/%3E%3C/svg%3E");
  opacity: 0.05;
  pointer-events: none;
}

/* ---------- шапка главы: общий стиль .sec-head/.sec-num/.sec-title
   (как у других блоков), цвета адаптированы под тёмный фон.
   Позиционирование + z — чтобы кубы не залезали на заголовок ---------- */
.showcase .sec-head {
  position: relative;
  z-index: 40;
  border-bottom-color: rgba(246, 241, 231, 0.14);
}

.showcase .sec-num {
  color: #f6f1e7;
  opacity: 0.22;
}

.showcase .sec-title {
  color: #fdfaf3;
}

/* ---------- сцена ---------- */
.stage {
  position: relative;
  z-index: 10;
  flex: 1 1 auto;
  min-height: 0;
  display: flex;
  padding-block: clamp(1.25rem, 3.5vh, 2.75rem);
}

.frame {
  position: relative;
  /* Референс: сцена ~3/4 ширины, по краям тёмные поля для кубов */
  width: min(86%, 1560px);
  margin-inline: auto;
  border-radius: var(--radius-lg);
  overflow: hidden;
  background-color: var(--color-surface-alt);
  box-shadow: 0 32px 110px rgba(0, 0, 0, 0.42);
}

.work-layer {
  position: absolute;
  inset: 0;
  background-color: var(--color-surface-alt);
}

.work-img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  /* Без параллакса: фото в рамке статично, глубину даёт только фон */
}

/* Верхний слой с текущим проектом: шторка clip-path по направлению
   навигации + ken-burns. Анимация перезапускается сменой :key слоя —
   без Vue-транзишнов, смена не зависит от leave-хуков */
.work-top {
  z-index: 2;
  animation: work-wipe 0.8s var(--ease-premium) both;
}
.frame[data-dir='prev'] .work-top {
  animation-name: work-wipe-prev;
}

@keyframes work-wipe {
  from {
    clip-path: inset(0 0 0 100%);
    opacity: 0.55;
  }
  to {
    clip-path: inset(0);
    opacity: 1;
  }
}
@keyframes work-wipe-prev {
  from {
    clip-path: inset(0 100% 0 0);
    opacity: 0.55;
  }
  to {
    clip-path: inset(0);
    opacity: 1;
  }
}

/* Ken-burns: новое фото «оседает» из лёгкого зума */
.work-top .work-img {
  animation: work-zoom 1.15s var(--ease-premium) both;
}
@keyframes work-zoom {
  from {
    transform: scale(1.09);
  }
  to {
    transform: scale(1);
  }
}

/* Кликовая зона смены проекта */
.stage-hit {
  position: absolute;
  inset: 0;
  z-index: 20;
  cursor: pointer;
  background: transparent;
  border: none;
}
.stage-hit:focus-visible {
  outline: 2px solid rgba(246, 241, 231, 0.9);
  outline-offset: -6px;
}

/* ---------- панель описания ---------- */
.panel {
  position: absolute;
  inset: 0 auto 0 0;
  z-index: 30;
  display: flex;
  flex-direction: column;
  width: min(46%, 620px);
  padding: clamp(1.5rem, 3vw, 3rem);
  background: linear-gradient(
    to right,
    rgba(26, 20, 14, 0.9) 0%,
    rgba(26, 20, 14, 0.72) 62%,
    rgba(26, 20, 14, 0) 100%
  );
  pointer-events: none;
}
.panel :deep(a),
.panel :deep(button) {
  pointer-events: auto;
}

.panel-idx {
  margin: 0;
  font-family: var(--font-mono);
  font-size: 0.8125rem;
  letter-spacing: 0.22em;
  color: rgba(246, 241, 231, 0.6);
}
.panel-idx span {
  opacity: 0.45;
}

.panel-main {
  flex: 1 1 auto;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: clamp(0.6rem, 1.4vh, 1rem);
  min-height: 0;
}

/* Ссылка — часть центрированной группы: нижняя зона панели остаётся
   свободной под наложение куба */
.panel-link {
  margin-top: clamp(0.5rem, 1.6vh, 1.25rem);
}

.panel-badge {
  margin: 0;
  font-size: var(--text-micro);
  font-weight: 600;
  letter-spacing: 0.24em;
  text-transform: uppercase;
  color: rgba(246, 241, 231, 0.66);
}

.panel-title {
  margin: 0;
  font-size: clamp(1.9rem, 3.3vw, 3.5rem);
  font-weight: 800;
  letter-spacing: -0.03em;
  line-height: 1.04;
  color: #fdfaf3;
  text-wrap: balance;
}

.panel-meta {
  margin: 0;
  font-family: var(--font-mono);
  font-size: var(--text-micro);
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: rgba(246, 241, 231, 0.55);
}

.panel-desc {
  margin: 0;
  max-width: 40ch;
  font-size: 0.9375rem;
  line-height: 1.6;
  color: rgba(246, 241, 231, 0.78);
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* «Смотреть проект»: круг-стрелка + подпись */
.panel-link {
  display: inline-flex;
  align-items: center;
  gap: 0.9rem;
  width: fit-content;
  text-decoration: none;
  color: #f6f1e7;
}

.panel-link-orb {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 3rem;
  height: 3rem;
  border: 1px solid rgba(246, 241, 231, 0.45);
  border-radius: 50%;
  transition:
    background-color var(--duration-base) var(--ease-premium),
    border-color var(--duration-base) var(--ease-premium),
    color var(--duration-base) var(--ease-premium),
    transform var(--duration-base) var(--ease-premium);
}
.panel-link:hover .panel-link-orb {
  background-color: #f6f1e7;
  border-color: #f6f1e7;
  color: var(--color-espresso);
  transform: translateX(4px);
}

.panel-link-label {
  font-size: var(--text-micro);
  font-weight: 600;
  letter-spacing: 0.2em;
  text-transform: uppercase;
}

/* Каскад появления содержимого панели: панель монтируется заново
   при каждой смене (:key), анимация детей стартует автоматически */
.panel-item {
  animation: panel-up 0.65s var(--ease-premium) both;
  animation-delay: calc(90ms + var(--pi) * 70ms);
}
@keyframes panel-up {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: none;
  }
}

/* ---------- управление: миниатюры + стрелки ---------- */
.controls {
  position: relative;
  z-index: 40;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: clamp(1rem, 2.5vw, 2rem);
  margin-top: clamp(0.9rem, 2vh, 1.5rem);
}

.thumbs {
  display: flex;
  gap: 0.625rem;
  overflow-x: auto;
  scrollbar-width: none;
}
.thumbs::-webkit-scrollbar {
  display: none;
}

.thumb {
  position: relative;
  flex-shrink: 0;
  width: 5.25rem;
  height: 3.5rem;
  padding: 0;
  border: 1px solid rgba(246, 241, 231, 0.22);
  border-radius: 10px;
  overflow: hidden;
  cursor: pointer;
  opacity: 0.55;
  transition:
    opacity var(--duration-fast) var(--ease-premium),
    border-color var(--duration-fast) var(--ease-premium),
    transform var(--duration-fast) var(--ease-premium);
}
.thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.thumb:hover {
  opacity: 0.85;
}
.thumb.is-active {
  opacity: 1;
  border-color: var(--color-gold);
  transform: translateY(-2px);
}

.nav {
  display: flex;
  align-items: center;
  gap: 0.625rem;
}

.nav-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2.75rem;
  height: 2.75rem;
  border: 1px solid rgba(246, 241, 231, 0.3);
  border-radius: 50%;
  background: transparent;
  color: #f6f1e7;
  cursor: pointer;
  transition:
    background-color var(--duration-fast) var(--ease-premium),
    border-color var(--duration-fast) var(--ease-premium),
    color var(--duration-fast) var(--ease-premium);
}
.nav-btn:hover {
  background-color: #f6f1e7;
  border-color: #f6f1e7;
  color: var(--color-espresso);
}

/* ---------- нижняя строка ---------- */
.show-foot {
  position: relative;
  z-index: 40;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
  margin-top: clamp(0.9rem, 2vh, 1.4rem);
  padding-top: clamp(0.9rem, 2vh, 1.2rem);
  border-top: 1px solid rgba(246, 241, 231, 0.14);
}

.foot-cats {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem 1.75rem;
  margin: 0;
  padding: 0;
  list-style: none;
}

/* Отступ под нижний левый куб (как на референсе: категории — правее куба) */
@media (min-width: 768px) {
  .foot-cats {
    padding-left: clamp(0px, 14vw, 224px);
  }
}

.foot-cat {
  padding: 0;
  border: none;
  background: none;
  cursor: pointer;
  font-family: var(--font-mono);
  font-size: var(--text-micro);
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: rgba(246, 241, 231, 0.45);
  transition: color var(--duration-fast) var(--ease-premium);
}
.foot-cat:hover:not(:disabled) {
  color: rgba(246, 241, 231, 0.9);
}
.foot-cat.is-active {
  color: var(--color-gold);
}
.foot-cat:disabled {
  cursor: default;
  opacity: 0.35;
}

.foot-tagline {
  margin: 0;
  flex-shrink: 0;
  font-family: var(--font-mono);
  font-size: var(--text-micro);
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: rgba(246, 241, 231, 0.5);
}

/* ---------- пустая выборка ---------- */
.stage-empty {
  position: relative;
  z-index: 10;
  flex: 1 1 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  color: rgba(246, 241, 231, 0.7);
}

/* ---------- каменные кубы ---------- */
.cubes {
  position: absolute;
  inset: 0;
  pointer-events: none;
  /* Без z-index: контейнер не создаёт stacking context, и каждый куб
     сам решает, перед сценой он (z 25) или за рамкой с фото (z 5) */
}

.cube {
  position: absolute;
  height: auto;
  /* База всех кубов опущена на 100px, сверху — параллакс: кубы отстают
     от прокрутки. --cs = (settleP − p): пока блок въезжает на экран —
     кубы ещё ниже, при полном размещении блока --cs = 0 и они стоят
     на 100px ниже базовых позиций, дальше уезжают вверх.
     Статический наклон живёт в rotate */
  translate: 0 calc(100px + var(--cs, 0) * var(--cs-speed, 0) * 1px);
}

/* Позиции по референсу: два верхних куба раздвинуты по краям блока
   и выглядывают из-за рамки (z 5), нижний левый — видимый, параллаксит
   вверх при уходе блока; правый крупный перед рамкой (z 25) */
.cube-a {
  width: 120px;
  top: 14%;
  left: 3.5%;
  rotate: -8deg;
  z-index: 5;
}
.cube-b {
  width: 250px;
  top: 38%;
  left: -150px;
  rotate: 10deg;
  z-index: 25;
}
.cube-c {
  width: 360px;
  bottom: -8%;
  left: -9%;
  rotate: 5deg;
  z-index: 25;
}
.cube-d {
  width: 140px;
  top: 4%;
  right: 3.5%;
  rotate: 14deg;
  z-index: 5;
}
.cube-e {
  width: 440px;
  top: 22%;
  right: -130px;
  rotate: -6deg;
  z-index: 25;
}

/* ---------- адаптив ---------- */
@media (max-width: 1279px) {
  .cube-e {
    width: 340px;
    right: -160px;
  }
  .cube-c {
    width: 360px;
  }
}

@media (max-width: 1023px) {
  .panel {
    width: min(58%, 540px);
  }
}

@media (max-width: 767px) {
  .stage {
    min-height: min(64svh, 560px);
  }

  /* Оставляем только два компактных куба по углам */
  .cube-a {
    width: 92px;
    top: 1.5%;
    left: 3%;
  }
  .cube-d {
    width: 84px;
    top: 2%;
    right: 3%;
  }
  .cube-b,
  .cube-c,
  .cube-e {
    display: none;
  }

  /* Панель — снизу, градиентом вверх от нижней кромки */
  .panel {
    inset: auto 0 0 0;
    width: 100%;
    padding: clamp(1.25rem, 4.5vw, 1.75rem);
    background: linear-gradient(
      to top,
      rgba(26, 20, 14, 0.92) 0%,
      rgba(26, 20, 14, 0.55) 58%,
      rgba(26, 20, 14, 0) 100%
    );
  }
  .panel-desc {
    display: none;
  }
  .panel-link-orb {
    width: 2.5rem;
    height: 2.5rem;
  }

  .controls {
    justify-content: space-between;
  }
  .thumb {
    width: 4.25rem;
    height: 2.875rem;
  }
  .nav-btn {
    width: 2.5rem;
    height: 2.5rem;
  }

  .show-foot {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.9rem;
  }
}

/* Низкие экраны: убираем описание, панель компактнее */
@media (max-height: 700px) and (min-width: 768px) {
  .panel-desc {
    display: none;
  }
}
</style>
