<script setup lang="ts">
import { computed } from 'vue'

/**
 * /blog — список статей.
 */
useSeo({
  title: 'Блог — статьи о дизайне интерьера',
  description: 'Гайды, тренды и кейсы о дизайне интерьера, 3D-визуализации и ремонте.',
})

const { data } = await usePosts({ limit: 12 })

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

const posts = computed(() => data.value?.docs || [])

function imgUrl(url?: string) {
  if (!url) return ''
  return url.startsWith('http') ? url : `${payloadBase}${url}`
}

function formatDate(date?: string) {
  if (!date) return ''
  return new Intl.DateTimeFormat('ru-RU', { day: 'numeric', month: 'long', year: 'numeric' }).format(new Date(date))
}
</script>

<template>
  <div>
    <section class="bg-[var(--color-surface)] pt-32">
      <div class="container-app pb-8">
        <p class="eyebrow">Блог</p>
        <h1 class="mt-3 font-display text-[var(--text-h1)]">Статьи и гайды</h1>
        <p class="mt-4 max-w-xl text-lg text-[var(--color-ink-muted)]">
          О дизайне, визуализации и ремонте — практично и без воды.
        </p>
      </div>
    </section>

    <section class="section">
      <div class="container-app">
        <div v-if="posts.length" class="grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
          <NuxtLink
            v-for="post in posts"
            :key="post.id"
            :to="`/blog/${post.slug}`"
            class="group flex flex-col overflow-hidden rounded-[var(--radius-lg)] bg-[var(--color-surface)] shadow-[var(--shadow-card)] transition-all duration-[var(--duration-base)] hover:shadow-[var(--shadow-hover)]"
          >
            <div v-if="post.coverImage?.url" class="aspect-[16/10] overflow-hidden">
              <NuxtImg
                :src="imgUrl(post.coverImage.url)"
                :alt="post.coverImage.alt || post.title"
                class="h-full w-full object-cover transition-transform duration-[var(--duration-slow)] group-hover:scale-105"
                sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
                format="webp,avif"
              />
            </div>
            <div class="flex flex-1 flex-col p-6">
              <div class="mb-2 flex items-center gap-3 text-xs text-[var(--color-ink-subtle)]">
                <span v-if="post.category?.title" class="text-[var(--color-accent)]">{{ post.category.title }}</span>
                <span>·</span>
                <time v-if="post.publishedAt">{{ formatDate(post.publishedAt) }}</time>
              </div>
              <h2 class="mb-2 font-display text-xl text-[var(--color-ink)] group-hover:text-[var(--color-accent)]">
                {{ post.title }}
              </h2>
              <p class="flex-1 text-sm text-[var(--color-ink-muted)]">{{ post.excerpt }}</p>
              <span class="link-arrow mt-4 text-sm">Читать</span>
            </div>
          </NuxtLink>
        </div>

        <div v-else class="py-20 text-center">
          <p class="text-[var(--color-ink-muted)]">Статьи скоро появятся.</p>
        </div>
      </div>
    </section>
  </div>
</template>
