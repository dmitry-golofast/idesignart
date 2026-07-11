<script setup lang="ts">
/**
 * HeroSection — полноэкранный hero для главной страницы.
 * Референс: Studio Ashby (full-bleed), Maverick Frame (продающий заголовок-результат).
 *
 * Контент приходит из Payload (Pages.hero) либо через props для демо.
 */
interface HeroCta {
  label?: string
  href?: string
}
interface HeroImage {
  url?: string
  alt?: string
  filename?: string
}

const props = defineProps<{
  headline?: string
  subheadline?: string
  image?: HeroImage | null
  ctaPrimary?: HeroCta | null
  ctaSecondary?: HeroCta | null
}>()

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

const defaults = {
  headline: 'Пространства, в которых хочется жить',
  subheadline: 'Дизайн интерьера и 3D-визуализация квартир, офисов и общественных пространств. От концепции до реализации.',
}

const headline = computed(() => props.headline || defaults.headline)
const subheadline = computed(() => props.subheadline || defaults.subheadline)

const imageUrl = computed(() => {
  const url = props.image?.url
  if (!url) return ''
  return url.startsWith('http') ? url : `${payloadBase}${url}`
})
</script>

<template>
  <section class="relative flex min-h-[90vh] items-end overflow-hidden bg-[var(--color-ink)]">
    <!-- Фоновое изображение (full-bleed) -->
    <img
      v-if="imageUrl"
      :src="imageUrl"
      :alt="image?.alt || headline"
      class="absolute inset-0 h-full w-full object-cover"
      fetchpriority="high"
    />
    <!-- Затемнение для читаемости текста -->
    <div class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/30 to-black/10" />

    <!-- Контент -->
    <div class="container-app relative z-[var(--z-content)] pb-16 pt-32 text-[var(--color-canvas)] lg:pb-24">
      <div class="max-w-3xl">
        <p class="eyebrow mb-6 text-[var(--color-accent-soft)]">
          Студия дизайна и визуализации
        </p>
        <h1 class="font-display text-[var(--text-display)] leading-[var(--text--display--line-height)] tracking-[var(--text--display--letter-spacing)]">
          {{ headline }}
        </h1>
        <p class="mt-6 max-w-xl text-lg text-[var(--color-canvas)]/85 lg:text-xl">
          {{ subheadline }}
        </p>

        <!-- CTA -->
        <div class="mt-10 flex flex-wrap gap-4">
          <UButton
            v-if="ctaPrimary?.href"
            :to="ctaPrimary.href"
            size="xl"
            color="primary"
            class="px-8"
          >
            {{ ctaPrimary.label || 'Смотреть работы' }}
          </UButton>
          <UButton
            v-if="ctaSecondary?.href"
            :to="ctaSecondary.href"
            size="xl"
            color="neutral"
            variant="outline"
            class="border-[var(--color-canvas)]/40 px-8  hover:bg-[var(--color-canvas)] hover:text-[var(--color-ink)]"
          >
            {{ ctaSecondary.label || 'Рассчитать стоимость' }}
          </UButton>
        </div>
      </div>
    </div>
  </section>
</template>
