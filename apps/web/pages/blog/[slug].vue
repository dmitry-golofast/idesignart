<script setup lang="ts">
import { computed } from 'vue'
import type { Post } from '@shared/types/payload'

const route = useRoute()
const slug = route.params.slug as string

const { data, error } = await usePost(slug)

if (error.value || !data.value?.docs?.length) {
  throw createError({ statusCode: 404, statusMessage: 'Статья не найдена', fatal: true })
}

// После throw выше — docs гарантированно есть.
const post = computed<Post>(() => data.value!.docs[0]!)

useSeo({
  title: post.value.seo?.title || post.value.title,
  description: post.value.seo?.description || post.value.excerpt,
  keywords: post.value.seo?.keywords,
  image: post.value.coverImage?.url,
  type: 'article',
  publishedTime: post.value.publishedAt,
  modifiedTime: post.value.updatedAt,
  author: post.value.author?.name,
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
  image: post.value.coverImage?.url ? imgUrl(post.value.coverImage.url) : undefined,
  datePublished: post.value.publishedAt,
  dateModified: post.value.updatedAt,
  author: { '@type': 'Person', name: post.value.author?.name || 'idesignart' },
  publisher: { '@type': 'Organization', name: 'idesignart' },
}))
</script>

<template>
  <article>
    <!-- Hero статьи -->
    <section class="bg-[var(--color-surface)] pt-32">
      <div class="container-app">
        <div class="mx-auto max-w-3xl pb-12">
          <NuxtLink to="/blog" class="link-arrow mb-8 text-sm">Все статьи</NuxtLink>
          <div class="mb-4 flex items-center gap-3 text-sm text-[var(--color-ink-subtle)]">
            <span v-if="post.category?.title" class="text-[var(--color-accent)]">{{ post.category.title }}</span>
            <span>·</span>
            <time v-if="post.publishedAt">{{ formatDate(post.publishedAt) }}</time>
            <span v-if="post.readingTime">· {{ post.readingTime }} мин чтения</span>
          </div>
          <h1 class="font-display text-[var(--text-h1)]">{{ post.title }}</h1>
          <p class="mt-4 text-lg text-[var(--color-ink-muted)]">{{ post.excerpt }}</p>
        </div>
      </div>
    </section>

    <!-- Обложка -->
    <div v-if="post.coverImage?.url" class="container-app">
      <NuxtImg
        :src="imgUrl(post.coverImage.url)"
        :alt="post.coverImage.alt || post.title"
        class="aspect-[16/9] w-full rounded-[var(--radius-lg)] object-cover"
        sizes="(max-width: 1024px) 100vw, 880px"
        format="webp,avif"
      />
    </div>

    <!-- Контент -->
    <section class="section">
      <div class="container-app">
        <div class="mx-auto max-w-3xl">
          <RichTextRenderer :content="post.content" />

          <!-- Автор -->
          <div v-if="post.author" class="mt-12 flex items-center gap-4 border-t border-[var(--color-line)] pt-8">
            <div>
              <p class="font-medium text-[var(--color-ink)]">{{ post.author.name }}</p>
              <p class="text-sm text-[var(--color-ink-subtle)]">Автор</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="section bg-[var(--color-surface-alt)]">
      <div class="container-app text-center">
        <h2 class="font-display text-[var(--text-h2)]">Понравилась статья?</h2>
        <p class="mx-auto mt-3 max-w-md text-[var(--color-ink-muted)]">
          Подпишитесь на новые материалы или обсудите свой проект с нами.
        </p>
        <div class="mt-8 flex justify-center gap-4">
          <UButton to="/contacts" color="primary" size="lg">Обсудить проект</UButton>
          <UButton to="/blog" color="neutral" variant="outline" size="lg">Все статьи</UButton>
        </div>
      </div>
    </section>

    <!-- JSON-LD -->
    <Script type="application/ld+json" v-html="articleJsonLd" />
  </article>
</template>
