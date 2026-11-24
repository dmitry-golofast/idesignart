<script setup lang="ts">
import { computed } from 'vue'
import type { Service } from '#shared/types/payload'

/**
 * /services/[slug] — посадочная страница услуги.
 * Структура по REFERENCES_AND_STRATEGY.md п. 3.3:
 * Hero → Боли → Решение → Портфолио по услуге → FAQ → CTA
 */
const route = useRoute()
const slug = route.params.slug as string

const { data, error } = await useService(slug)

if (error.value || !data.value?.docs?.length) {
  throw createError({ statusCode: 404, statusMessage: 'Услуга не найдена', fatal: true })
}

// После throw выше — docs гарантированно есть. Явный тип снимает undefined.
const service = computed<Service>(() => data.value!.docs[0]!)

// Связи Payload сужает автоимпортируемый populated() из utils/payload.ts.
// heroImage заполнен не у всех услуг — без него берём cardImage (есть у каждой)
const heroImage = computed(() =>
  populated(service.value.heroImage) ?? populated(service.value.cardImage),
)
const relatedProjects = computed(() =>
  (service.value.relatedProjects ?? [])
    .map((p) => populated(p))
    .filter((p): p is NonNullable<typeof p> => p !== null),
)

useSeo({
  title: service.value.meta?.title || service.value.title,
  description: service.value.meta?.description || service.value.shortDescription,
  image: heroImage.value?.url ?? undefined,
  noindex: service.value.meta?.noindex ?? false,
  type: 'website',
})

// FAQ → JSON-LD микроразметка
const faqJsonLd = computed(() => {
  if (!service.value.faqs?.length) return null
  return {
    '@context': 'https://schema.org',
    '@type': 'FAQPage',
    mainEntity: service.value.faqs.map((f) => ({
      '@type': 'Question',
      name: f.question,
      acceptedAnswer: { '@type': 'Answer', text: f.answer },
    })),
  }
})

// JSON-LD отдаём через <head> — разметка попадает и в серверный HTML.
// В шаблоне для этого использовался <Script>, но Nuxt такой компонент не
// регистрирует («Failed to resolve component: Script»), а v-html с объектом
// записывал в тег «[object Object]»
useHead(() => ({
  script: faqJsonLd.value
    ? [{ key: 'faq-json-ld', type: 'application/ld+json', innerHTML: jsonLd(faqJsonLd.value) }]
    : [],
}))

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string
const heroImg = computed(() => {
  const url = heroImage.value?.url
  if (!url) return ''
  return url.startsWith('http') ? url : `${payloadBase}${url}`
})

const propertyLabels: Record<string, string> = {
  apartment: 'Квартира', house: 'Дом', office: 'Офис',
  hospitality: 'HoReCa', retail: 'Retail', other: 'Другое',
}

// FAQ для аккордеона UI kit: label/content/value — поля элемента UAccordion
const faqItems = computed(() =>
  (service.value.faqs ?? []).map((f, i) => ({ label: f.question, content: f.answer, value: String(i) })),
)
// Подпись и ответ аккордеона крупнее дефолтных 14px — читаются как основной текст
// страницы; ответ — тёмным (ink-muted даёт контраст 4.2:1 на фоне страницы).
// Каждый вопрос — карточка на подложке: с одними линиями снизу (дефолт темы)
// аккордеон сливался с фоном страницы
const accordionUi = {
  item: 'mb-3 rounded-[var(--radius-lg)] border border-[var(--color-line)] bg-[var(--color-surface)] px-6 last:mb-0 last:border-b',
  trigger: 'py-4 text-base font-semibold text-[var(--color-ink)] lg:text-lg',
  body: 'pb-5 text-base leading-[1.65] text-[var(--color-ink)]',
  trailingIcon: 'size-5 text-[var(--color-ink)]',
}

const priceLabel = computed(() =>
  service.value.pricing?.priceFrom
    ? new Intl.NumberFormat('ru-RU').format(service.value.pricing.priceFrom)
    : '',
)
const unitLabel = computed(() => {
  const unit = service.value.pricing?.unit
  return unit === 'sqm' ? 'м²' : unit === 'project' ? 'проект' : unit ?? ''
})
</script>

<template>
  <article>
    <!-- Hero -->
    <section class="relative flex min-h-[60vh] items-end overflow-hidden bg-[var(--color-ink)] pt-24">
      <NuxtImg
        v-if="heroImg"
        :src="heroImg"
        :alt="service.heroHeadline"
        class="absolute inset-0 h-full w-full object-cover opacity-60"
        sizes="lg:100vw 2xl:100vw 100vw"
        format="webp,avif"
        preload
      />
      <div class="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent" />
      <!-- Цвет задаётся на самих заголовках: глобальное правило h1–h4 в main.css
           (color: var(--color-ink)) не даёт унаследовать светлый цвет контейнера -->
      <div class="container-app relative z-10 pb-16 text-[var(--color-canvas)]">
        <h1 class="max-w-3xl font-display text-h1 text-[var(--color-canvas)]">
          {{ service.heroHeadline || service.title }}
        </h1>
        <p v-if="service.heroSubheadline" class="mt-4 max-w-xl text-lg text-[var(--color-canvas)]/80">
          {{ service.heroSubheadline }}
        </p>
      </div>
    </section>

    <div class="container-app section">
      <!-- minmax(0,1fr): колонка контента не тянется за самым длинным
           непереносимым словом, а сжимается под сетку; overflow-wrap:anywhere
           переносит такие слова. Без этого одна длинная строка без пробелов
           растягивала колонку на несколько тысяч пикселей -->
      <div class="grid gap-12 lg:grid-cols-[minmax(0,1fr)_320px] lg:gap-16">
        <!-- Основной контент. max-w-[46rem] на текстовых блоках — строка около
             80 символов, длиннее читать тяжело -->
        <div class="min-w-0 [overflow-wrap:anywhere]">
          <!-- Боли клиента -->
          <section v-if="service.painPoints?.length">
            <h2 class="content-heading">Знакомо?</h2>
            <!-- Список — в карточке, как и пункты «Что входит» -->
            <ul class="mt-6 max-w-[46rem] space-y-4 rounded-[var(--radius-lg)] border border-[var(--color-line)] bg-[var(--color-surface)] p-6">
              <li
                v-for="(pain, i) in service.painPoints"
                :key="i"
                class="flex gap-4 text-lg leading-[1.6] text-[var(--color-ink)]"
              >
                <UIcon name="i-lucide-alert-circle" class="mt-1 h-5 w-5 shrink-0 text-[var(--color-accent-deep)]" />
                <span>{{ pain.point }}</span>
              </li>
            </ul>
          </section>

          <!-- Что входит -->
          <section v-if="service.deliverables?.length" class="mt-14">
            <h2 class="content-heading">Что входит</h2>
            <div class="mt-6 grid gap-4 sm:grid-cols-2 lg:gap-6">
              <div
                v-for="(d, i) in service.deliverables"
                :key="i"
                class="rounded-[var(--radius-lg)] border border-[var(--color-line)] bg-[var(--color-surface)] p-6"
              >
                <div class="flex items-start gap-3">
                  <UIcon name="i-lucide-check" class="mt-1 h-5 w-5 shrink-0 text-[var(--color-success)]" />
                  <h3 class="text-lg font-semibold leading-snug text-[var(--color-ink)]">{{ d.item }}</h3>
                </div>
                <p v-if="d.description" class="mt-2 pl-8 text-base leading-[1.6] text-[var(--color-ink-muted)]">
                  {{ d.description }}
                </p>
              </div>
            </div>
          </section>

          <!-- Подробное описание (Lexical rich text): основной текст — тёмным -->
          <section v-if="service.body" class="mt-14 max-w-[46rem] [&_p]:text-[var(--color-ink)]">
            <RichTextRenderer :content="service.body" text-class="text-lg" />
          </section>

          <!-- FAQ: аккордеон из UI kit (Nuxt UI) -->
          <section v-if="faqItems.length" class="mt-14">
            <h2 class="content-heading">Частые вопросы</h2>
            <UAccordion :items="faqItems" type="single" collapsible class="mt-4" :ui="accordionUi" />
          </section>
        </div>

        <!-- Сайдбар: цена + CTA -->
        <aside class="min-w-0 [overflow-wrap:anywhere] lg:sticky lg:top-28 lg:self-start">
          <div class="rounded-[var(--radius-lg)] border border-[var(--color-line)] bg-[var(--color-surface)] p-6 lg:p-7">
            <p class="eyebrow text-[var(--color-ink)]">Стоимость</p>
            <p
              v-if="priceLabel"
              class="mt-3 text-[2rem] leading-[1.1] font-extrabold tracking-[-0.02em] text-[var(--color-ink)]"
            >
              от {{ priceLabel }} ₽
              <span class="text-base font-medium tracking-normal text-[var(--color-ink-muted)]">/ {{ unitLabel }}</span>
            </p>
            <p v-else class="mt-3 text-base leading-[1.6] text-[var(--color-ink-muted)]">
              Рассчитаем стоимость под ваш объект
            </p>
            <p v-if="service.pricing?.note" class="mt-2 text-base leading-[1.5] text-[var(--color-ink-muted)]">
              {{ service.pricing.note }}
            </p>
            <NuxtLink to="/contacts" class="btn-lime mt-6 w-full">
              Оставить заявку
              <UIcon name="i-lucide-arrow-right" class="h-4 w-4" aria-hidden="true" />
            </NuxtLink>
          </div>
        </aside>
      </div>
    </div>

    <!-- Примеры работ по услуге: отдельный список-карусель -->
    <ServicesProjectsCarousel
      v-if="relatedProjects.length"
      :projects="relatedProjects"
      title="Примеры работ"
    />
  </article>
</template>

