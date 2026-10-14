<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import type { Media } from '#shared/types/payload'

/**
 * ProcessSteps — процесс работы (редизайн v3.2, референс ayocin:
 * pinned-секция, где текст меняется по скроллу «With the ATMOS, you…»).
 *
 * Механика: секция высотой N×100vh, внутри — прилипающая сцена во весь экран.
 * Шапка главы (номер + заголовок + hairline-прогресс) видна всегда, пока
 * крутятся шаги. У каждого шага фоновая картинка (поле image в CMS): слои
 * кроссфейдятся при смене активного шага, поверх — центрированный текст шага,
 * который сменяется анимацией. Без картинки — эспрессо-градиент с номером.
 *
 * На мобильных (<lg) пиннинг отключён: шаги идут колонкой, у каждого —
 * своя картинка-панель. Данные из CMS (props.steps) или дефолтные.
 */

interface ProcessStep {
  num: string
  title: string
  description: string
  duration?: string
  image?: Media | number | null
  sketch?: 'plan' | 'iso' | 'elevation' | 'perspective' | string | null
}

const props = defineProps<{
  eyebrow?: string
  title?: string
  description?: string
  steps?: ProcessStep[]
  /** Номер главы — присваивается по порядку блоков на странице (PageSections) */
  num?: number
  // Игнорируем технические props от PageSections
  id?: string
  blockType?: string
}>()

const payloadBase = useRuntimeConfig().public.payloadApiUrl as string

const secNum = computed(() => String(props.num ?? 1).padStart(2, '0'))

const defaultSteps: ProcessStep[] = [
  { num: '01', title: 'Брифинг и концепция', description: 'Изучаем задачи, образ жизни, референсы. Формируем концепцию и планировочное решение.', duration: '1–2 недели', sketch: 'plan' },
  { num: '02', title: '3D-визуализация', description: 'Создаём фотореалистичные рендеры каждого помещения. Вы видите результат до ремонта.', duration: '2–4 недели', sketch: 'iso' },
  { num: '03', title: 'Рабочая документация', description: 'Чертежи, спецификации, смета. Все материалы и оборудование — с точным указанием.', duration: '2–3 недели', sketch: 'elevation' },
  { num: '04', title: 'Авторский надзор', description: 'Контролируем ход ремонта, корректируем отклонения. Сдаём готовый объект под ключ.', duration: 'до сдачи', sketch: 'perspective' },
]

const displaySteps = computed<(Omit<ProcessStep, 'image'> & { image: Media | null })[]>(() =>
  (Array.isArray(props.steps) && props.steps.length > 0 ? props.steps : defaultSteps)
    .map((s) => ({ ...s, image: populated(s.image ?? null) })),
)

/** Сужает строку из CMS до допустимого типа чертежа ProcessSketch */
const SKETCH_TYPES = ['plan', 'iso', 'elevation', 'perspective'] as const
type SketchType = (typeof SKETCH_TYPES)[number]
function sketchType(v: string | null | undefined): SketchType {
  return (SKETCH_TYPES as readonly string[]).includes(v ?? '') ? (v as SketchType) : 'plan'
}

function imageUrl(image: Media | null): string | null {
  if (!image?.url) return null
  return image.url.startsWith('http') ? image.url : `${payloadBase}${image.url}`
}

/* --- scroll-driven состояние --- */
const rootEl = ref<HTMLElement | null>(null)
const progress = ref(0)
// Порог переключения — на полшага позже середины: сцена меняется, когда
// следующая шаг-зона уже наполовину пройдена, а не на границе шага
const active = computed(() => {
  const n = displaySteps.value.length
  return Math.min(n - 1, Math.max(0, Math.floor((progress.value - 0.5 / n) * n)))
})
const currentStep = computed(() => displaySteps.value[active.value])

let ticking = false
function updateProgress() {
  ticking = false
  const el = rootEl.value
  if (!el) return
  const rect = el.getBoundingClientRect()
  const scrollable = el.offsetHeight - window.innerHeight
  const passed = Math.min(Math.max(-rect.top, 0), scrollable)
  progress.value = scrollable > 0 ? passed / scrollable : 0
}
function onScroll() {
  if (!ticking) {
    ticking = true
    requestAnimationFrame(updateProgress)
  }
}
onMounted(() => {
  updateProgress()
  window.addEventListener('scroll', onScroll, { passive: true })
  window.addEventListener('resize', onScroll, { passive: true })
})
onBeforeUnmount(() => {
  window.removeEventListener('scroll', onScroll)
  window.removeEventListener('resize', onScroll)
})
</script>

<template>
  <section class="relative">
    <!-- ===== Desktop: pinned-сцена (ayocin «With the ATMOS…») ===== -->
    <div
      ref="rootEl"
      class="relative hidden lg:block"
      :style="{ height: `${displaySteps.length * 100}vh` }"
    >
      <div class="sticky top-0 h-[100svh] overflow-hidden bg-[var(--color-espresso)] text-[#f6f1e7]">
        <!-- Фоновые картинки шагов: кроссфейд по активному шагу -->
        <div
          v-for="(step, i) in displaySteps"
          :key="step.num"
          class="absolute inset-0 transition-opacity duration-700 ease-[var(--ease-premium)]"
          :class="active === i ? 'opacity-100' : 'opacity-0'"
          aria-hidden="true"
        >
          <img
            v-if="imageUrl(step.image)"
            class="h-full w-full object-cover"
            :src="imageUrl(step.image)!"
            alt=""
            loading="lazy"
          />
          <!-- Фолбэк без картинки: эспрессо-градиент + призрачный номер -->
          <div v-else class="h-full w-full bg-[radial-gradient(120%_90%_at_70%_20%,var(--color-espresso-soft),var(--color-espresso))]">
            <span class="absolute right-[6vw] top-1/2 -translate-y-1/2 font-display text-[24vw] leading-none font-bold tracking-[-0.05em] text-[#f6f1e7]/6">
              {{ step.num }}
            </span>
          </div>
        </div>

        <!-- Затемнение под читаемость текста -->
        <div
          class="absolute inset-0 bg-gradient-to-t from-black/72 via-black/38 to-black/45"
          aria-hidden="true"
        />

        <!-- Шапка главы: всегда видна, hairline = прогресс-линия -->
        <div class="absolute inset-x-0 top-0 pt-[96px]">
          <div class="container-app">
            <div class="flex items-baseline gap-[clamp(1.5rem,4vw,4rem)] pb-5">
              <span class="font-display text-[clamp(1.75rem,3.2vw,4rem)] leading-none font-bold tracking-[-0.02em] text-[#f6f1e7]">
                {{ secNum }}
              </span>
              <h2 class="font-display text-[clamp(1.75rem,3.2vw,3.5rem)] leading-none font-extrabold tracking-[-0.03em] text-[#f6f1e7]">
                {{ title || 'Как мы работаем' }}
              </h2>
            </div>
            <!-- Линия-прогресс: заполняется золотым по мере прохождения шагов -->
            <div class="relative h-px bg-[#f6f1e7]/25">
              <div
                class="absolute inset-y-0 left-0 w-full origin-left bg-[var(--color-gold)]"
                :style="{ transform: `scaleX(${progress})` }"
              />
            </div>
          </div>
        </div>

        <!-- Текст активного шага: центрированный statement, сменяется по скроллу -->
        <div class="absolute inset-0 flex items-center justify-center">
          <Transition name="step-swap" mode="out-in">
            <div :key="active" class="max-w-3xl px-[var(--container-pad)] text-center">
              <p class="meta-label !justify-center !text-[#f6f1e7]/80">
                Шаг {{ currentStep?.num }}<template v-if="currentStep?.duration"> — {{ currentStep.duration }}</template>
              </p>
              <h3 class="mt-5 font-display text-[clamp(2rem,4vw,4rem)] leading-[1.06] font-extrabold tracking-[-0.03em] text-[#f6f1e7]">
                {{ currentStep?.title }}
              </h3>
              <p class="mx-auto mt-5 max-w-xl text-[17px] leading-relaxed text-[#f6f1e7]/75">
                {{ currentStep?.description }}
              </p>
            </div>
          </Transition>
        </div>

        <!-- Нижняя строка сцены -->
        <div class="absolute inset-x-0 bottom-0">
          <div class="container-app flex items-center justify-between pb-6">
            <span class="text-[11px] tracking-[0.18em] text-[#f6f1e7]/60 uppercase">Листайте вниз</span>
            <span class="font-mono text-[11px] tracking-[0.2em] text-[#f6f1e7]/60">
              {{ String(active + 1).padStart(2, '0') }} / {{ String(displaySteps.length).padStart(2, '0') }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== Mobile: шаги колонкой, у каждого своя картинка ===== -->
    <div class="bg-[var(--color-canvas)] pb-16 lg:hidden">
      <div class="container-app pt-4">
        <div class="sec-head" data-reveal>
          <span class="sec-num" aria-hidden="true">{{ secNum }}</span>
          <h2 class="sec-title">{{ title || 'Как мы работаем' }}</h2>
        </div>
        <p v-if="description" class="mt-4 max-w-md text-[15px] leading-relaxed text-[var(--color-ink-muted)]">
          {{ description }}
        </p>
      </div>

      <div class="mt-8 space-y-6 px-[var(--container-pad)]">
        <article
          v-for="step in displaySteps"
          :key="step.num"
          class="relative flex min-h-[68svh] flex-col justify-end overflow-hidden rounded-[var(--radius-lg)] bg-[var(--color-espresso)] p-6 text-[#f6f1e7]"
          data-reveal
        >
          <img
            v-if="imageUrl(step.image)"
            class="absolute inset-0 h-full w-full object-cover"
            :src="imageUrl(step.image)!"
            alt=""
            loading="lazy"
          />
          <div v-else class="absolute inset-0 bg-[radial-gradient(120%_90%_at_70%_20%,var(--color-espresso-soft),var(--color-espresso))]" />
          <div class="absolute inset-0 bg-gradient-to-t from-black/78 via-black/35 to-black/20" aria-hidden="true" />

          <div class="relative">
            <p class="meta-label !text-[#f6f1e7]/80">
              Шаг {{ step.num }}<template v-if="step.duration"> — {{ step.duration }}</template>
            </p>
            <h3 class="mt-3 text-[26px] leading-tight font-bold tracking-[-0.02em] text-[#f6f1e7]">
              {{ step.title }}
            </h3>
            <p class="mt-3 text-[15px] leading-relaxed text-[#f6f1e7]/75">
              {{ step.description }}
            </p>
          </div>
        </article>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Смена шага: текст уезжает вверх, новый приезжает снизу (ayocin-стиль) */
.step-swap-enter-active,
.step-swap-leave-active {
  transition:
    opacity 0.45s var(--ease-premium),
    transform 0.45s var(--ease-premium);
}
.step-swap-enter-from {
  opacity: 0;
  transform: translate3d(0, 28px, 0);
}
.step-swap-leave-to {
  opacity: 0;
  transform: translate3d(0, -20px, 0);
}
</style>
