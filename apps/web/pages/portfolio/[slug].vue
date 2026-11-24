<script setup lang="ts">
import { computed } from 'vue'
import type { Project } from '#shared/types/payload'

/**
 * /portfolio/[slug] — страница кейса.
 * Главный SEO-актив для long-tail трафика.
 * Структура по REFERENCES_AND_STRATEGY.md п. 3.4.
 *
 * Скелет и типографика — как у посадочной услуги (/services/[slug]):
 * hero с заголовком text-h1 → контент слева (max-w-[46rem]) и липкая
 * карточка справа с параметрами проекта и кнопкой заявки.
 */
const route = useRoute()
const slug = route.params.slug as string

const { data, error } = await useProject(slug)

if (error.value || !data.value?.docs?.length) {
  throw createError({ statusCode: 404, statusMessage: 'Проект не найден', fatal: true })
}

// После throw выше — docs гарантированно есть.
const project = computed<Project>(() => data.value!.docs[0]!)

// coverImage — связь Payload (number | Media) → объект
const coverImage = computed(() => populated(project.value.coverImage))

useSeo({
  title: project.value.meta?.title || `${project.value.title} — дизайн-проект`,
  description: project.value.meta?.description || project.value.excerpt,
  image: coverImage.value?.url,
  noindex: project.value.meta?.noindex ?? false,
  type: 'article',
})

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

function imgUrl(url?: string) {
  if (!url) return ''
  return url.startsWith('http') ? url : `${payloadBase}${url}`
}

const details = computed(() => project.value.details || {})

const propertyLabels: Record<string, string> = {
  apartment: 'Квартира', house: 'Дом', office: 'Офис',
  hospitality: 'HoReCa', retail: 'Retail', other: 'Другое',
}
const styleLabels: Record<string, string> = {
  modern: 'Современный', minimal: 'Минимализм', scandi: 'Скандинавский',
  loft: 'Лофт', classic: 'Классика', neoclassic: 'Неоклассика', japandi: 'Джапанди',
}

// Параметры проекта — в карточке справа (там, где у услуги цена).
// Выводим только заполненные
const facts = computed(() =>
  (
    [
      { label: 'Площадь', value: details.value.area ? `${details.value.area} м²` : '' },
      {
        label: 'Тип',
        value: details.value.propertyType
          ? propertyLabels[details.value.propertyType] || details.value.propertyType
          : '',
      },
      {
        label: 'Стиль',
        value: details.value.style ? styleLabels[details.value.style] || details.value.style : '',
      },
      { label: 'Срок', value: details.value.duration || '' },
    ] as { label: string; value: string }[]
  ).filter((f) => f.value),
)
</script>

<template>
  <article>
    <!-- Hero — как на странице услуги. Цвет задаётся на самом заголовке:
         глобальное правило h1–h4 в main.css (color: var(--color-ink)) не даёт
         унаследовать светлый цвет контейнера -->
    <section class="relative flex min-h-[60vh] items-end overflow-hidden bg-[var(--color-ink)] pt-24">
      <NuxtImg
        v-if="coverImage?.url"
        :src="imgUrl(coverImage.url)"
        :alt="coverImage.alt || project.title"
        class="absolute inset-0 h-full w-full object-cover opacity-60"
        sizes="lg:100vw 2xl:100vw 100vw"
        format="webp,avif"
        preload
      />
      <div class="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent" />
      <div class="container-app relative z-10 pb-16 text-[var(--color-canvas)]">
        <h1 class="max-w-3xl font-display text-h1 text-[var(--color-canvas)]">{{ project.title }}</h1>
        <p v-if="project.excerpt" class="mt-4 max-w-xl text-lg text-[var(--color-canvas)]/80">
          {{ project.excerpt }}
        </p>
      </div>
    </section>

    <div class="container-app section">
      <!-- minmax(0,1fr) + overflow-wrap:anywhere — колонка контента не тянется
           за непереносимыми словами (та же защита, что на странице услуги) -->
      <div class="grid gap-12 lg:grid-cols-[minmax(0,1fr)_320px] lg:gap-16">
        <!-- Основной контент -->
        <div class="min-w-0 [overflow-wrap:anywhere]">
          <!-- Задача -->
          <section v-if="project.brief">
            <h2 class="content-heading">Задача</h2>
            <RichTextRenderer
              :content="project.brief"
              text-class="text-lg"
              class="mt-6 max-w-[46rem] [&_p]:text-[var(--color-ink)]"
            />
          </section>

          <!-- Решение -->
          <section v-if="project.solution" class="mt-14">
            <h2 class="content-heading">Решение</h2>
            <RichTextRenderer
              :content="project.solution"
              text-class="text-lg"
              class="mt-6 max-w-[46rem] [&_p]:text-[var(--color-ink)]"
            />
          </section>

          <!-- Галерея: все картинки из CMS одной каруселью -->
          <PortfolioGalleryCarousel
            v-if="project.gallery?.length"
            class="mt-14"
            :gallery="project.gallery"
            :title="project.title"
          />

          <!-- Отзыв — карточка, как вопросы FAQ на странице услуги -->
          <section v-if="project.testimonial?.quote" class="mt-14">
            <h2 class="content-heading">Отзыв</h2>
            <figure class="mt-6 max-w-[46rem] rounded-[var(--radius-lg)] border border-[var(--color-line)] bg-[var(--color-surface)] p-6 lg:p-7">
              <blockquote class="text-lg leading-[1.6] text-[var(--color-ink)]">
                «{{ project.testimonial.quote }}»
              </blockquote>
              <figcaption class="mt-4 text-base text-[var(--color-ink-muted)]">
                <span class="font-semibold text-[var(--color-ink)]">{{ project.testimonial.author }}</span>
                <template v-if="project.testimonial.role"> · {{ project.testimonial.role }}</template>
              </figcaption>
            </figure>
          </section>
        </div>

        <!-- Сайдбар: параметры проекта + CTA (у услуги здесь цена) -->
        <aside class="min-w-0 [overflow-wrap:anywhere] lg:sticky lg:top-28 lg:self-start">
          <div class="rounded-[var(--radius-lg)] border border-[var(--color-line)] bg-[var(--color-surface)] p-6 lg:p-7">
            <p class="eyebrow text-[var(--color-ink)]">О проекте</p>
            <dl v-if="facts.length" class="mt-4">
              <div
                v-for="f in facts"
                :key="f.label"
                class="flex items-baseline justify-between gap-6 border-b border-[var(--color-line)] py-3 first:pt-0 last:border-b-0 last:pb-0"
              >
                <dt class="text-base text-[var(--color-ink-muted)]">{{ f.label }}</dt>
                <dd class="text-right text-base font-medium text-[var(--color-ink)]">{{ f.value }}</dd>
              </div>
            </dl>
            <NuxtLink to="/contacts" class="btn-lime mt-6 w-full">
              Оставить заявку
              <UIcon name="i-lucide-arrow-right" class="h-4 w-4" aria-hidden="true" />
            </NuxtLink>
          </div>
        </aside>
      </div>
    </div>
  </article>
</template>
