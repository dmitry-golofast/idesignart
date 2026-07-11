<script setup lang="ts">
/**
 * ProcessSteps — пронумерованная схема процесса работы (3–5 шагов).
 * Референс: Heanly Harris.
 * Снимает страх клиента, повышает доверие → конверсию.
 *
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
      <div class="mb-16 max-w-2xl">
        <p class="eyebrow text-[var(--color-accent-soft)]">{{ props.eyebrow || 'Как мы работаем' }}</p>
        <h2 class="mt-3 font-display text-[var(--text-h2)] text-[var(--color-canvas)]">
          {{ props.title || 'Прозрачный процесс от идеи до переезда' }}
        </h2>
        <p class="mt-4 text-[var(--color-canvas)]/70">
          Вы всегда знаете, на каком этапе проект и что будет дальше.
        </p>
      </div>

      <!-- Шаги -->
      <div class="grid gap-8 md:grid-cols-2 lg:grid-cols-4">
        <div
          v-for="(step, i) in displaySteps"
          :key="step.num"
          class="group relative"
        >
          <!-- Линия между шагами (desktop) -->
          <div
            v-if="i < displaySteps.length - 1"
            class="absolute left-[3.25rem] top-8 hidden h-px w-[calc(100%-2rem)] bg-[var(--color-canvas)]/15 lg:block"
          />

          <div class="relative">
            <!-- Номер -->
            <div class="mb-6 flex h-16 w-16 items-center justify-center rounded-full border border-[var(--color-canvas)]/20 font-display text-2xl text-[var(--color-accent-soft)] transition-colors duration-[var(--duration-base)] group-hover:border-[var(--color-accent)] group-hover:text-[var(--color-accent)]">
              {{ step.num }}
            </div>

            <h3 class="mb-3 font-display text-xl text-[var(--color-canvas)]">
              {{ step.title }}
            </h3>
            <p class="mb-4 text-sm leading-relaxed text-[var(--color-canvas)]/70">
              {{ step.description }}
            </p>
            <p class="text-xs uppercase tracking-[var(--tracking-caps)] text-[var(--color-canvas)]/40">
              {{ step.duration }}
            </p>
          </div>
        </div>
      </div>

      <!-- CTA -->
      <div class="mt-16 text-center">
        <UButton to="/process" size="lg" color="primary">
          Подробнее о процессе
        </UButton>
      </div>
    </div>
  </section>
</template>
