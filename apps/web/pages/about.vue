<script setup lang="ts">
useSeo({
  title: 'О студии — idesignart',
  description: 'Студия дизайна интерьера и 3D-визуализации. Команда, подход, ценности.',
})

const values = [
  {
    icon: 'i-lucide-pen-tool',
    title: 'Авторский подход',
    text: 'Не шаблонные решения. Каждый проект — под образ жизни и задачи клиента.',
  },
  {
    icon: 'i-lucide-eye',
    title: 'Визуализация прежде всего',
    text: 'Вы видите результат в 3D до начала ремонта. Никаких сюрпризов.',
  },
  {
    icon: 'i-lucide-shield-check',
    title: 'Прозрачная смета',
    text: 'Фиксированная стоимость работ. Без скрытых платежей и доплат.',
  },
  {
    icon: 'i-lucide-clock',
    title: 'Соблюдение сроков',
    text: 'Чёткий план-график. Договор с ответственностью за просрочку.',
  },
]
</script>

<template>
  <div>
    <!-- Hero -->
    <section class="bg-[var(--color-surface)] pt-32">
      <div class="container-app pb-16">
        <div class="max-w-3xl">
          <p class="eyebrow">О студии</p>
          <h1 class="page-title mt-3">
            Создаём пространства, в которых хочется жить и работать
          </h1>
          <p class="mt-6 text-lg text-[var(--color-ink-muted)]">
            idesignart — студия дизайна интерьера и 3D-визуализации.
            Мы проектируем квартиры, дома и общественные пространства,
            объединяя эстетику и функциональность.
          </p>
        </div>
      </div>
    </section>

    <!-- Ценности -->
    <section class="section">
      <div class="container-app">
        <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          <div
            v-for="v in values"
            :key="v.title"
            class="rounded-xl border border-[var(--color-line)] bg-[var(--color-surface)] p-7 transition-colors duration-300 hover:border-[var(--color-ink)]"
          >
            <span class="mb-5 flex h-10 w-10 items-center justify-center rounded-full border border-[var(--color-lime)] bg-[var(--color-lime)]/10">
              <UIcon :name="v.icon" class="h-5 w-5 text-[var(--color-ink)]" aria-hidden="true" />
            </span>
            <h3 class="mb-2 text-lg font-bold text-[var(--color-ink)]">{{ v.title }}</h3>
            <p class="text-sm text-[var(--color-ink-muted)]">{{ v.text }}</p>
          </div>
        </div>
      </div>
    </section>

    <BlocksProcessSteps />
    <BlocksContactForm
      eyebrow="Сотрудничество"
      title="Давайте познакомимся"
      description="Расскажите о вашем проекте — предложим решение."
      source="about-page"
    />
  </div>
</template>
