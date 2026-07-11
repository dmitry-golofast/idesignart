<script setup lang="ts">
useSeo({
  title: 'Политика конфиденциальности — idesignart',
  description: 'Политика обработки персональных данных сайта idesignart.',
  noindex: true,
})

const config = useRuntimeConfig()
const email = config.public.email as string
const year = new Date().getFullYear()
</script>

<template>
  <div>
    <section class="bg-[var(--color-surface)] pt-32">
      <div class="container-app pb-8">
        <p class="eyebrow">Документ</p>
        <h1 class="mt-3 font-display text-[var(--text-h1)]">Политика конфиденциальности</h1>
        <p class="mt-2 text-sm text-[var(--color-ink-subtle)]">Последнее обновление: {{ year }}</p>
      </div>
    </section>

    <section class="section">
      <div class="container-app">
        <div class="prose-content mx-auto max-w-3xl space-y-6 text-[var(--color-ink-muted)]">
          <h2 class="font-display text-[var(--text-h3)] text-[var(--color-ink)]">1. Общие положения</h2>
          <p>
            Настоящая Политика обработки персональных данных составлена в соответствии с
            требованиями применимого законодательства и определяет порядок обработки
            персональных данных и меры по обеспечению безопасности персональных данных.
          </p>

          <h2 class="font-display text-[var(--text-h3)] text-[var(--color-ink)]">2. Какие данные мы собираем</h2>
          <ul class="list-disc space-y-2 pl-6 marker:text-[var(--color-accent)]">
            <li>Имя, email, телефон — при заполнении форм на сайте</li>
            <li>Информация о проекте (тип помещения, площадь, бюджет) — при отправке заявки</li>
            <li>Технические данные (cookie, IP-адрес) — для аналитики и работы сайта</li>
          </ul>

          <h2 class="font-display text-[var(--text-h3)] text-[var(--color-ink)]">3. Цели обработки</h2>
          <ul class="list-disc space-y-2 pl-6 marker:text-[var(--color-accent)]">
            <li>Связь с вами по поводу вашего проекта</li>
            <li>Отправка материалов (лид-магниты, рассылки — только с вашего согласия)</li>
            <li>Улучшение качества сайта и услуг</li>
          </ul>

          <h2 class="font-display text-[var(--text-h3)] text-[var(--color-ink)]">4. Хранение и передача</h2>
          <p>
            Мы не передаём ваши персональные данные третьим лицам, за исключением случаев,
            предусмотренных законодательством. Данные хранятся на защищённых серверах.
          </p>

          <h2 class="font-display text-[var(--text-h3)] text-[var(--color-ink)]">5. Ваши права</h2>
          <p>
            Вы можете в любой момент запросить удаление ваших данных, отписаться от рассылки
            или уточнить обрабатываемые данные, написав на
            <a :href="`mailto:${email}`" class="text-[var(--color-accent)] underline">{{ email }}</a>.
          </p>
        </div>
      </div>
    </section>
  </div>
</template>
