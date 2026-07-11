<script setup lang="ts">
import { computed } from 'vue'
import type { Project } from '@shared/types/payload'

/**
 * /portfolio/[slug] — страница кейса.
 * Главный SEO-актив для long-tail трафика.
 * Структура по REFERENCES_AND_STRATEGY.md п. 3.4.
 */
const route = useRoute()
const slug = route.params.slug as string

const { data, error } = await useProject(slug)

if (error.value || !data.value?.docs?.length) {
  throw createError({ statusCode: 404, statusMessage: 'Проект не найден', fatal: true })
}

// После throw выше — docs гарантированно есть.
const project = computed<Project>(() => data.value!.docs[0]!)

useSeo({
  title: project.value.seo?.title || `${project.value.title} — дизайн-проект`,
  description: project.value.seo?.description || project.value.excerpt,
  keywords: project.value.seo?.keywords,
  image: project.value.coverImage?.url,
  type: 'article',
})

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

function imgUrl(url?: string) {
  if (!url) return ''
  return url.startsWith('http') ? url : `${payloadBase}${url}`
}

const meta = computed(() => project.value.meta || {})

const propertyLabels: Record<string, string> = {
  apartment: 'Квартира', house: 'Дом', office: 'Офис',
  hospitality: 'HoReCa', retail: 'Retail', other: 'Другое',
}
const styleLabels: Record<string, string> = {
  modern: 'Современный', minimal: 'Минимализм', scandi: 'Скандинавский',
  loft: 'Лофт', classic: 'Классика', neoclassic: 'Неоклассика', japandi: 'Джапанди',
}

// Разбиваем галерею на before/after для сравнения
const beforeImages = computed(() => project.value.gallery?.filter((g) => g.type === 'before') || [])
const renderImages = computed(() => project.value.gallery?.filter((g) => g.type === 'render') || [])
const afterImages = computed(() => project.value.gallery?.filter((g) => g.type === 'after') || [])

// Type guard: gallery.image может быть ID (string) при depth < 2
function isMedia(img: any): img is { url?: string; alt?: string } {
  return img && typeof img === 'object' && 'url' in img
}
// Безопасно достаём URL картинки из элемента галереи
function galleryUrl(g: { image?: any }): string {
  return isMedia(g.image) ? imgUrl(g.image.url) : ''
}
function galleryAlt(g: { image?: any }, fallback: string): string {
  return isMedia(g.image) ? (g.image.alt || fallback) : fallback
}
</script>

<template>
  <article>
    <!-- Hero кейса -->
    <section class="relative min-h-[70vh] overflow-hidden bg-[var(--color-ink)] pt-20">
      <NuxtImg
        v-if="project.coverImage?.url"
        :src="imgUrl(project.coverImage.url)"
        :alt="project.coverImage.alt || project.title"
        class="absolute inset-0 h-full w-full object-cover opacity-70"
        sizes="100vw"
        format="webp,avif"
        preload
      />
      <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent" />
      <div class="container-app relative z-10 flex min-h-[70vh] flex-col justify-end pb-16 text-[var(--color-canvas)]">
        <p class="eyebrow mb-4 text-[var(--color-accent-soft)]">Кейс</p>
        <h1 class="max-w-4xl font-display text-[var(--text-h1)]">{{ project.title }}</h1>
        <p class="mt-4 max-w-2xl text-lg text-[var(--color-canvas)]/80">{{ project.excerpt }}</p>

        <!-- Метаданные -->
        <dl v-if="meta" class="mt-8 grid grid-cols-2 gap-6 text-sm sm:grid-cols-4">
          <div v-if="meta.area">
            <dt class="text-[var(--color-canvas)]/50">Площадь</dt>
            <dd class="mt-1 text-[var(--color-canvas)]">{{ meta.area }} м²</dd>
          </div>
          <div v-if="meta.propertyType">
            <dt class="text-[var(--color-canvas)]/50">Тип</dt>
            <dd class="mt-1 text-[var(--color-canvas)]">{{ propertyLabels[meta.propertyType] || meta.propertyType }}</dd>
          </div>
          <div v-if="meta.style">
            <dt class="text-[var(--color-canvas)]/50">Стиль</dt>
            <dd class="mt-1 text-[var(--color-canvas)]">{{ styleLabels[meta.style] || meta.style }}</dd>
          </div>
          <div v-if="meta.duration">
            <dt class="text-[var(--color-canvas)]/50">Срок</dt>
            <dd class="mt-1 text-[var(--color-canvas)]">{{ meta.duration }}</dd>
          </div>
        </dl>
      </div>
    </section>

    <div class="container-app section">
      <div class="mx-auto max-w-3xl">
        <!-- Задача -->
        <section v-if="project.brief" class="mb-16">
          <h2 class="mb-4 font-display text-[var(--text-h2)]">Задача</h2>
          <RichTextRenderer :content="project.brief" />
        </section>

        <!-- Решение -->
        <section v-if="project.solution" class="mb-16">
          <h2 class="mb-4 font-display text-[var(--text-h2)]">Решение</h2>
          <RichTextRenderer :content="project.solution" />
        </section>
      </div>

      <!-- Галерея -->
      <section v-if="renderImages.length" class="my-16">
        <h2 class="mb-8 font-display text-[var(--text-h2)]">3D-визуализация</h2>
        <div class="grid gap-6 sm:grid-cols-2">
          <figure
            v-for="(img, i) in renderImages"
            :key="i"
            class="overflow-hidden rounded-[var(--radius-lg)]"
          >
            <NuxtImg
              v-if="galleryUrl(img)"
              :src="galleryUrl(img)"
              :alt="img.caption || galleryAlt(img, project.title)"
              class="w-full object-cover"
              sizes="(max-width: 640px) 100vw, 50vw"
              format="webp,avif"
            />
            <figcaption v-if="img.caption" class="mt-2 text-sm text-[var(--color-ink-subtle)]">
              {{ img.caption }}
            </figcaption>
          </figure>
        </div>
      </section>

      <!-- Реализация (после) -->
      <section v-if="afterImages.length" class="my-16">
        <h2 class="mb-8 font-display text-[var(--text-h2)]">Реализация</h2>
        <div class="grid gap-6 sm:grid-cols-2">
          <figure
            v-for="(img, i) in afterImages"
            :key="i"
            class="overflow-hidden rounded-[var(--radius-lg)]"
          >
            <NuxtImg
              v-if="galleryUrl(img)"
              :src="galleryUrl(img)"
              :alt="img.caption || galleryAlt(img, project.title)"
              class="w-full object-cover"
              sizes="(max-width: 640px) 100vw, 50vw"
              format="webp,avif"
            />
          </figure>
        </div>
      </section>

      <!-- Отзыв -->
      <section v-if="project.testimonial?.quote" class="my-16">
        <div class="mx-auto max-w-3xl rounded-[var(--radius-xl)] bg-[var(--color-surface-alt)] p-10 text-center">
          <UIcon name="i-lucide-quote" class="mx-auto mb-4 h-10 w-10 text-[var(--color-accent-soft)]" />
          <blockquote class="font-display text-2xl text-[var(--color-ink)]">
            «{{ project.testimonial.quote }}»
          </blockquote>
          <div class="mt-6">
            <p class="font-medium text-[var(--color-ink)]">{{ project.testimonial.author }}</p>
            <p v-if="project.testimonial.role" class="text-sm text-[var(--color-ink-subtle)]">
              {{ project.testimonial.role }}
            </p>
          </div>
        </div>
      </section>

      <!-- CTA -->
      <div class="my-16 rounded-[var(--radius-xl)] bg-[var(--color-ink)] p-10 text-center text-[var(--color-canvas)]">
        <h2 class="font-display text-[var(--text-h2)] text-[var(--color-canvas)]">Хотите так же?</h2>
        <p class="mt-3 text-[var(--color-canvas)]/70">Обсудим ваш проект и предложим решение.</p>
        <UButton to="/contacts" color="primary" size="lg" class="mt-6">Оставить заявку</UButton>
      </div>
    </div>
  </article>
</template>
