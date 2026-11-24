<script setup lang="ts">
import { computed } from 'vue'
import type { Category, Post } from '#shared/types/payload'

const route = useRoute()
const slug = route.params.slug as string

const { data, error } = await usePost(slug)

if (error.value || !data.value?.docs?.length) {
  throw createError({ statusCode: 404, statusMessage: 'Статья не найдена', fatal: true })
}

// После throw выше — docs гарантированно есть.
const post = computed<Post>(() => data.value!.docs[0]!)

// Связи Payload (number | Media / number | User / number | Category) → объекты
const coverImage = computed(() => populated(post.value.coverImage))
const author = computed(() => populated(post.value.author))
// Категории те же, что у проектов; в шапке показываем первую
const categories = computed(() =>
  (post.value.categories ?? [])
    .map((c) => populated(c))
    .filter((c): c is NonNullable<typeof c> => Boolean(c)),
)

// Теги статьи (hasMany-связь с отдельной коллекцией tags) → объекты
const tags = computed(() =>
  (post.value.tags ?? [])
    .map((t) => populated(t))
    .filter((t): t is NonNullable<typeof t> => Boolean(t)),
)

useSeo({
  title: post.value.meta?.title || post.value.title,
  description: post.value.meta?.description || post.value.excerpt,
  image: coverImage.value?.url,
  noindex: post.value.meta?.noindex ?? false,
  type: 'article',
  publishedTime: post.value.publishedAt,
  modifiedTime: post.value.updatedAt,
  author: author.value?.name,
})

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

function imgUrl(url?: string) {
  if (!url) return ''
  return url.startsWith('http') ? url : `${payloadBase}${url}`
}

function formatDate(date?: string) {
  if (!date) return ''
  return new Intl.DateTimeFormat('ru-RU', { day: 'numeric', month: 'long', year: 'numeric' }).format(new Date(date))
}

// Article JSON-LD
const articleJsonLd = computed(() => ({
  '@context': 'https://schema.org',
  '@type': 'Article',
  headline: post.value.title,
  description: post.value.excerpt,
  image: coverImage.value?.url ? imgUrl(coverImage.value.url) : undefined,
  datePublished: post.value.publishedAt,
  dateModified: post.value.updatedAt,
  author: { '@type': 'Person', name: author.value?.name || 'idesignart' },
  publisher: { '@type': 'Organization', name: 'idesignart' },
  keywords: tags.value.map((t) => t.title).join(', ') || undefined,
}))

// JSON-LD отдаём через <head> — разметка попадает и в серверный HTML.
// В шаблоне для этого использовался <Script>, но Nuxt такой компонент не
// регистрирует («Failed to resolve component: Script»), а v-html с объектом
// записывал в тег «[object Object]»
useHead(() => ({
  script: [{ key: 'article-json-ld', type: 'application/ld+json', innerHTML: jsonLd(articleJsonLd.value) }],
}))
</script>

<template>
  <article>
    <!-- Hero статьи -->
    <section class="bg-surface pt-16">
      <div class="container-app">
        <div class="mx-auto max-w-3xl pb-12">
          <div class="mb-4 flex gap-3 text-sm text-ink-subtle">
            <span v-if="categories[0]?.title" class="text-accent-deep">{{ categories[0].title }}</span>
            <time v-if="post.publishedAt">{{ formatDate(post.publishedAt) }}</time>
            <span v-if="post.readingTime">· {{ post.readingTime }} мин чтения</span>
          </div>
          <h1 class="page-title">{{ post.title }}</h1>
          <p class="mt-4 text-lg text-ink-muted">{{ post.excerpt }}</p>

          <!-- Теги статьи: ключевые слова, отдельная сущность от категорий -->
          <div v-if="tags.length" class="mt-6 flex flex-wrap gap-2">
            <span
              v-for="tag in tags"
              :key="tag.id"
              class="rounded-[var(--radius-pill)] border border-[var(--color-line)] px-3.5 py-1.5 text-xs text-[var(--color-ink-muted)]"
            >
              {{ tag.title }}
            </span>
          </div>
        </div>
      </div>
    </section>

    <!-- Обложка -->
    <div v-if="coverImage?.url" class="container-app">
      <NuxtImg
        :src="imgUrl(coverImage.url)"
        :alt="coverImage.alt || post.title"
        class="aspect-video w-full rounded-lg object-cover"
        sizes="xl:880px 100vw"
        format="webp,avif"
      />
    </div>

    <!-- Контент -->
    <section class="section">
      <div class="container-app">
        <div class="mx-auto max-w-3xl">
          <RichTextRenderer :content="post.content" />

          <!-- Автор -->
          <div v-if="author" class="mt-12 flex items-center gap-4 border-t border-[var(--color-line)] pt-8">
            <div>
              <p class="font-medium text-[var(--color-ink)]">{{ author.name }}</p>
              <p class="text-sm text-[var(--color-ink-subtle)]">Автор</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="section bg-[var(--color-surface-alt)]">
      <div class="container-app">
        <div class="max-w-2xl">
          <h2 class="section-title">Понравилась статья?</h2>
          <p class="mt-4 text-[var(--color-ink-muted)]">
            Подпишитесь на новые материалы или обсудите свой проект с нами.
          </p>
          <div class="mt-8 flex flex-wrap gap-3">
            <NuxtLink to="/contacts" class="btn-lime">
              Обсудить проект
              <UIcon name="i-lucide-arrow-right" class="h-4 w-4" aria-hidden="true" />
            </NuxtLink>
            <UButton to="/blog" color="neutral" variant="outline" size="lg">Все статьи</UButton>
          </div>
        </div>
      </div>
    </section>
  </article>
</template>
