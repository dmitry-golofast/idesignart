<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'

/**
 * ProcessSteps — процесс работы в механике scrollytelling (как блок
 * «How it works» на galvanite.io, блок grid-how-step).
 *
 * Пока секция прокручивается, шаги-панели (высотой в экран) «наезжают»
 * друг на друга (sticky), а справа остаётся прилипшая визуальная панель,
 * в которой по мере скролла сменяются чертежи (canvas, ProcessSketch).
 * Сверху — прогресс-линия, заполняющаяся по мере прохождения шагов.
 *
 * На мобильных (<lg) скролл-механика отключается: шаги идут обычной
 * колонкой, у каждого — свой небольшой чертёж.
 * Данные приходят из CMS (props.steps) или дефолтные.
 */

interface ProcessStep {
  num: string
  title: string
  description: string
  duration?: string
  sketch?: 'plan' | 'iso' | 'elevation' | 'perspective' | string | null
}

const props = defineProps<{
  eyebrow?: string
  title?: string
  description?: string
  steps?: ProcessStep[]
  // Игнорируем технические props от PageSections
  id?: string
  blockType?: string
}>()

const defaultSteps: ProcessStep[] = [
  { num: '01', title: 'Брифинг и концепция', description: 'Изучаем задачи, образ жизни, референсы. Формируем концепцию и планировочное решение.', duration: '1–2 недели', sketch: 'plan' },
  { num: '02', title: '3D-визуализация', description: 'Создаём фотореалистичные рендеры каждого помещения. Вы видите результат до ремонта.', duration: '2–4 недели', sketch: 'iso' },
  { num: '03', title: 'Рабочая документация', description: 'Чертежи, спецификации, смета. Все материалы и оборудование — с точным указанием.', duration: '2–3 недели', sketch: 'elevation' },
  { num: '04', title: 'Авторский надзор', description: 'Контролируем ход ремонта, корректируем отклонения. Сдаём готовый объект под ключ.', duration: 'до сдачи', sketch: 'perspective' },
]

const displaySteps = computed<ProcessStep[]>(() =>
  Array.isArray(props.steps) && props.steps.length > 0 ? props.steps : defaultSteps,
)

const SKETCH_LABELS: Record<string, string> = {
  plan: 'План',
  iso: 'Изометрия',
  elevation: 'Развертка',
  perspective: 'Перспектива',
}

/** Отступ sticky = высота шапки (CMS, default 88px) */
const STICKY_TOP = 88

/* --- scroll-driven состояние --- */
const rootEl = ref<HTMLElement | null>(null)
const progress = ref(0)
const active = computed(() =>
  Math.min(displaySteps.value.length - 1, Math.floor(progress.value * displaySteps.value.length)),
)

let ticking = false
function updateProgress() {
  ticking = false
  const el = rootEl.value
  if (!el) return
  const rect = el.getBoundingClientRect()
  const scrollable = el.offsetHeight - window.innerHeight + STICKY_TOP
  const passed = Math.min(Math.max(-rect.top + STICKY_TOP, 0), scrollable)
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
  <section ref="rootEl" class="relative bg-[var(--color-canvas)] pb-16 pt-20 lg:pt-28">
    <!-- Шапка блока (в обычном потоке, уходит при скролле) -->
    <div class="container-app">
      <p class="font-mono text-xs font-medium uppercase tracking-[0.24em] text-[var(--color-ink-muted)]">
        idesignart
        <span class="text-[var(--color-ink-subtle)]">/</span>
        {{ eyebrow || 'Процесс' }}
      </p>
      <h2 class="section-title mt-4">{{ title || 'Как мы работаем' }}</h2>
      <p v-if="description" class="mt-3 text-[var(--color-ink-muted)]">
        {{ description }}
      </p>
    </div>

    <!-- Прогресс-линия: заполняется по мере прохождения шагов (поверх панелей, у нижней кромки шапки) -->
    <div class="sticky top-[88px] z-30 hidden lg:block" aria-hidden="true">
      <div class="container-app">
        <div class="h-[2px] overflow-hidden bg-[var(--color-line)]">
          <div
            class="h-full origin-left bg-[var(--color-lime)] transition-transform duration-150 ease-linear"
            :style="{ transform: `scaleX(${progress})` }"
          />
        </div>
      </div>
    </div>

    <div class="lg:flex">
      <!-- Колонка шагов: sticky-панели наезжают друг на друга -->
      <div class="lg:w-[46%]">
        <article
          v-for="(step, i) in displaySteps"
          :key="step.num"
          class="flex flex-col justify-center bg-[var(--color-canvas)] px-[var(--container-pad)] py-14 lg:sticky lg:top-[88px] lg:h-[calc(100vh-88px)] lg:py-0"
        >
          <!-- Мобильный чертёж -->
          <div class="process-grid mb-8 h-44 border border-[var(--color-line)]/60 lg:hidden">
            <BlocksProcessSketch :type="step.sketch || 'plan'" />
          </div>

          <p class="font-mono text-xs font-medium uppercase tracking-[0.24em] text-[var(--color-ink-muted)]">
            <span class="font-bold text-[var(--color-accent-deep)]">{{ step.num }}</span>
            <span class="text-[var(--color-ink-subtle)]"> / </span>
            {{ String(displaySteps.length).padStart(2, '0') }}
          </p>

          <h2 class="page-title mt-4">{{ step.title }}</h2>
          <p class="mt-5 max-w-xl text-[17px] leading-relaxed text-[var(--color-ink-muted)]">
            {{ step.description }}
          </p>

          <div
            v-if="step.duration"
            class="mt-8 max-w-xl border-t border-[var(--color-line)] pt-4 font-mono text-[11px] uppercase tracking-[0.22em] text-[var(--color-ink-muted)]"
          >
            Срок — {{ step.duration }}
          </div>
        </article>
      </div>

      <!-- Визуальная панель: прилипает, чертежи сменяются по скроллу -->
      <div class="hidden lg:flex lg:w-[54%]">
        <div class="sticky top-[88px] flex h-[calc(100vh-88px)] w-full items-center pl-6 pr-[var(--container-pad)]">
          <div class="relative w-full overflow-hidden rounded-[4px] border border-[var(--color-line)] bg-[var(--color-surface)] shadow-[var(--shadow-card)]">
            <!-- Миллиметровка -->
            <div class="process-grid absolute inset-0" aria-hidden="true" />

            <!-- Чертежи: кроссфейд по активному шагу -->
            <div class="relative h-[62vh]">
              <BlocksProcessSketch
                v-for="(step, i) in displaySteps"
                :key="step.num"
                :type="step.sketch || 'plan'"
                class="absolute inset-5 transition-opacity duration-700 ease-[var(--ease-premium)]"
                :class="active === i ? 'opacity-100' : 'opacity-0'"
              />
            </div>

            <!-- Подвал панели: подпись чертежа + счётчик -->
            <div class="relative flex items-center justify-between border-t border-[var(--color-line)] px-6 py-4">
              <span class="font-mono text-[11px] uppercase tracking-[0.22em] text-[var(--color-ink-muted)]">
                {{ SKETCH_LABELS[displaySteps[active]?.sketch || 'plan'] || 'Чертёж' }}
              </span>
              <span class="flex items-center gap-2">
                <span
                  v-for="(s, i) in displaySteps"
                  :key="s.num"
                  class="h-1.5 w-6 transition-colors duration-500"
                  :class="active === i ? 'bg-[var(--color-lime)]' : 'bg-[var(--color-line)]'"
                />
                <span class="ml-2 font-mono text-[11px] text-[var(--color-ink-muted)]">
                  {{ String(active + 1).padStart(2, '0') }} / {{ String(displaySteps.length).padStart(2, '0') }}
                </span>
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Миллиметровка (как на листах чертежей) */
.process-grid {
  background-image:
    linear-gradient(color-mix(in srgb, var(--color-line) 55%, transparent) 1px, transparent 1px),
    linear-gradient(90deg, color-mix(in srgb, var(--color-line) 55%, transparent) 1px, transparent 1px);
  background-size: 22px 22px;
  background-position: center;
}
</style>
