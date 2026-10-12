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

// Сужаем связи Payload (number | Media / number | Category) до объектов
const posts = computed(() =>
  (data.value?.docs || []).map((post) => ({
    ...post,
    cover: populated(post.coverImage),
    category: populated(post.category),
  })),
)

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
        <h1 class="page-title mt-3">Статьи и гайды</h1>
        <p class="mt-4 max-w-xl text-lg text-[var(--color-ink-muted)]">
          О дизайне, визуализации и ремонте — практично и без воды.
        </p>
      </div>
    </section>

    <section class="section">
      <div class="container-app">
        <div v-if="posts.length" class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          <NuxtLink
            v-for="post in posts"
            :key="post.id"
            :to="`/blog/${post.slug}`"
            class="group flex flex-col overflow-hidden rounded-xl border border-[var(--color-line)] bg-[var(--color-surface)] transition-colors duration-300 hover:border-[var(--color-ink)]"
          >
            <div v-if="post.cover?.url" class="aspect-[16/10] overflow-hidden">
              <NuxtImg
                :src="imgUrl(post.cover.url)"
                :alt="post.cover.alt || post.title"
                class="h-full w-full object-cover transition-transform duration-300 group-hover:scale-[1.03]"
                sizes="sm:50vw lg:33vw 100vw"
                format="webp,avif"
              />
            </div>
            <div class="flex flex-1 flex-col p-6">
              <div class="mb-2 flex items-center gap-3 text-xs text-[var(--color-ink-subtle)]">
                <span v-if="post.category?.title" class="text-[var(--color-accent-deep)]">{{ post.category.title }}</span>
                <span>·</span>
                <time v-if="post.publishedAt">{{ formatDate(post.publishedAt) }}</time>
              </div>
              <h2 class="mb-2 text-lg font-bold tracking-[-0.01em] text-[var(--color-ink)]">
                {{ post.title }}
              </h2>
              <p class="flex-1 text-sm text-[var(--color-ink-muted)]">{{ post.excerpt }}</p>
              <span class="mt-4 inline-flex items-center gap-1.5 text-sm font-medium text-[var(--color-ink)] underline decoration-[var(--color-line)] decoration-1 underline-offset-4 transition-colors duration-200 group-hover:decoration-[var(--color-ink)]">
                Читать
                <UIcon name="i-lucide-arrow-right" class="h-4 w-4" aria-hidden="true" />
              </span>
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
