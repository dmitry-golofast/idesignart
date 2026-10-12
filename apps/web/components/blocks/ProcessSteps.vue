<script setup lang="ts">
/**
 * ProcessSteps — пронумерованная схема процесса работы (3–5 шагов).
 * Тёмная секция — ритм главной страницы; номера — фирменный лайм.
 * Данные приходят из CMS (props.steps) или дефолтные.
 */

const props = defineProps<{
  eyebrow?: string
  title?: string
  steps?: { num: string; title: string; description: string; duration?: string }[]
  // Игнорируем технические props от PageSections
  id?: string
  blockType?: string
}>()

const defaultSteps = [
  { num: '01', title: 'Брифинг и концепция', description: 'Изучаем задачи, образ жизни, референсы. Формируем концепцию и планировочное решение.', duration: '1–2 недели' },
  { num: '02', title: '3D-визуализация', description: 'Создаём фотореалистичные рендеры каждого помещения. Вы видите результат до ремонта.', duration: '2–4 недели' },
  { num: '03', title: 'Рабочая документация', description: 'Чертежи, спецификации, смета. Все материалы и оборудование — с точным указанием.', duration: '2–3 недели' },
  { num: '04', title: 'Авторский надзор', description: 'Контролируем ход ремонта, корректируем отклонения. Сдаём готовый объект под ключ.', duration: 'до сдачи' },
]

// Безопасное значение: если steps нет/пустой — дефолтные.
// Без computed, чтобы исключить проблемы при SSR.
const displaySteps = Array.isArray(props.steps) && props.steps.length > 0
  ? props.steps
  : defaultSteps
</script>

<template>
  <section class="section bg-[var(--color-ink)] text-[var(--color-canvas)]">
    <div class="container-app">
      <div class="mb-14 max-w-2xl">
        <p class="text-xs font-semibold uppercase tracking-[0.24em] text-[var(--color-canvas)]/50">
          {{ props.eyebrow || 'Как мы работаем' }}
        </p>
        <h2 class="section-title mt-3 text-[var(--color-canvas)]">
          {{ props.title || 'Прозрачный процесс от идеи до переезда' }}
        </h2>
        <p class="mt-4 text-[var(--color-canvas)]/60">
          Вы всегда знаете, на каком этапе проект и что будет дальше.
        </p>
      </div>

      <!-- Шаги -->
      <div class="grid gap-10 md:grid-cols-2 lg:grid-cols-4 lg:gap-8">
        <div
          v-for="(step, i) in displaySteps"
          :key="step.num"
          class="relative border-t-2 border-[var(--color-canvas)]/15 pt-6"
        >
          <!-- Лаймовый номер — акцент на тёмном -->
          <p class="text-4xl font-extrabold tracking-[-0.02em] text-[var(--color-lime)]">
            {{ step.num }}
          </p>

          <h3 class="mb-3 mt-4 text-lg font-bold text-[var(--color-canvas)]">
            {{ step.title }}
          </h3>
          <p class="mb-4 text-sm leading-relaxed text-[var(--color-canvas)]/60">
            {{ step.description }}
          </p>
          <p class="text-xs font-semibold uppercase tracking-[0.18em] text-[var(--color-canvas)]/40">
            {{ step.duration }}
          </p>
        </div>
      </div>

      <!-- CTA -->
      <div class="mt-14">
        <NuxtLink to="/process" class="btn-lime">
          Подробнее о процессе
          <UIcon name="i-lucide-arrow-right" class="h-4 w-4" aria-hidden="true" />
        </NuxtLink>
      </div>
    </div>
  </section>
</template>
