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
          <h1 class="mt-3 font-display text-[var(--text-h1)]">
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
        <div class="grid gap-8 sm:grid-cols-2 lg:grid-cols-4">
          <div
            v-for="v in values"
            :key="v.title"
            class="rounded-[var(--radius-lg)] bg-[var(--color-surface)] p-8 shadow-[var(--shadow-card)]"
          >
            <UIcon :name="v.icon" class="mb-5 h-10 w-10 text-[var(--color-accent)]" />
            <h3 class="mb-2 font-display text-xl">{{ v.title }}</h3>
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
