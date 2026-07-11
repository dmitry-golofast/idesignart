<script setup lang="ts">
import { computed } from 'vue'
import type { Service } from '@shared/types/payload'

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

useSeo({
  title: service.value.seo?.title || service.value.title,
  description: service.value.seo?.description || service.value.shortDescription,
  keywords: service.value.seo?.keywords,
  image: service.value.heroImage?.url,
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

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string
const heroImg = computed(() => {
  const url = service.value.heroImage?.url
  if (!url) return ''
  return url.startsWith('http') ? url : `${payloadBase}${url}`
})

const propertyLabels: Record<string, string> = {
  apartment: 'Квартира', house: 'Дом', office: 'Офис',
  hospitality: 'HoReCa', retail: 'Retail', other: 'Другое',
}
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
        sizes="100vw"
        format="webp,avif"
        preload
      />
      <div class="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent" />
      <div class="container-app relative z-10 pb-16 text-[var(--color-canvas)]">
        <p class="eyebrow mb-4 text-[var(--color-accent-soft)]">Услуга</p>
        <h1 class="max-w-3xl font-display text-[var(--text-h1)]">
          {{ service.heroHeadline || service.title }}
        </h1>
        <p v-if="service.heroSubheadline" class="mt-4 max-w-xl text-lg text-[var(--color-canvas)]/80">
          {{ service.heroSubheadline }}
        </p>
      </div>
    </section>

    <div class="container-app section">
      <div class="grid gap-16 lg:grid-cols-[1fr_320px]">
        <!-- Основной контент -->
        <div>
          <!-- Боли клиента -->
          <div v-if="service.painPoints?.length">
            <h2 class="font-display text-[var(--text-h2)]">Знакомо?</h2>
            <ul class="mt-6 space-y-4">
              <li
                v-for="(pain, i) in service.painPoints"
                :key="i"
                class="flex gap-3 text-[var(--color-ink-muted)]"
              >
                <UIcon name="i-lucide-alert-circle" class="mt-1 h-5 w-5 shrink-0 text-[var(--color-accent)]" />
                <span>{{ pain.point }}</span>
              </li>
            </ul>
          </div>

          <!-- Что входит -->
          <div v-if="service.deliverables?.length" class="mt-16">
            <h2 class="font-display text-[var(--text-h2)]">Что входит</h2>
            <div class="mt-6 grid gap-6 sm:grid-cols-2">
              <div
                v-for="(d, i) in service.deliverables"
                :key="i"
                class="rounded-[var(--radius-lg)] bg-[var(--color-surface)] p-6 shadow-[var(--shadow-xs)]"
              >
                <div class="mb-2 flex items-center gap-2">
                  <UIcon name="i-lucide-check" class="h-5 w-5 text-[var(--color-success)]" />
                  <h3 class="font-medium text-[var(--color-ink)]">{{ d.item }}</h3>
                </div>
                <p v-if="d.description" class="text-sm text-[var(--color-ink-muted)]">{{ d.description }}</p>
              </div>
            </div>
          </div>

          <!-- Подробное описание (Lexical rich text) -->
          <div v-if="service.body" class="mt-16 max-w-none">
            <RichTextRenderer :content="service.body" />
          </div>

          <!-- FAQ -->
          <div v-if="service.faqs?.length" class="mt-16">
            <h2 class="font-display text-[var(--text-h2)]">Частые вопросы</h2>
            <UAccordion
              :items="service.faqs.map((f, i) => ({ label: f.question, content: f.answer, key: String(i) }))"
              class="mt-6"
            />
          </div>
        </div>

        <!-- Сайдбар: цена + CTA -->
        <aside class="lg:sticky lg:top-28 lg:self-start">
          <div class="rounded-[var(--radius-lg)] bg-[var(--color-surface)] p-6 shadow-[var(--shadow-card)]">
            <p class="text-xs uppercase tracking-[var(--tracking-caps)] text-[var(--color-ink-subtle)]">Стоимость</p>
            <p v-if="service.pricing?.priceFrom" class="mt-2 font-display text-3xl text-[var(--color-ink)]">
              от {{ new Intl.NumberFormat('ru-RU').format(service.pricing.priceFrom) }} ₽
              <span class="text-base text-[var(--color-ink-muted)]">
                / {{ service.pricing.unit === 'sqm' ? 'м²' : service.pricing.unit === 'project' ? 'проект' : service.pricing.unit }}
              </span>
            </p>
            <p v-if="service.pricing?.note" class="mt-1 text-sm text-[var(--color-ink-muted)]">
              {{ service.pricing.note }}
            </p>
            <UButton to="/contacts" color="primary" size="lg" class="mt-6 w-full justify-center">
              Оставить заявку
            </UButton>
          </div>
        </aside>
      </div>
    </div>

    <!-- Портфолио по услуге -->
    <BlocksPortfolioMasonry
      v-if="service.relatedProjects?.length"
      :projects="service.relatedProjects"
      eyebrow="Кейсы по этой услуге"
      title="Примеры работ"
    />

    <!-- JSON-LD FAQ -->
    <ClientOnly v-if="faqJsonLd">
      <Script type="application/ld+json" v-html="faqJsonLd" />
    </ClientOnly>
  </article>
</template>
