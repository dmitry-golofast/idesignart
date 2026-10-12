<script setup lang="ts">
import { computed } from 'vue'
import type { Service } from '#shared/types/payload'

/**
 * ServicesGrid — сетка карточек услуг.
 * Единый язык с блоком «Наши работы»: белые карточки, тонкая граница,
 * номер, гротеск-заголовок, ссылка «Подробнее →».
 *
 * Берёт услуги из Payload через useServices() либо принимает через props.
 */
const props = defineProps<{
  services?: Service[]
  title?: string
  eyebrow?: string
  description?: string
}>()

// Если услуги не переданы — тянем опубликованные featured.
// icon — связь Payload (number | Media), сужаем до объекта для шаблона.
const { data } = useServices({ featuredOnly: !props.services?.length })
const services = computed(() =>
  (props.services?.length ? props.services : (data.value?.docs || []))
    .map((s) => ({ ...s, icon: populated(s.icon) })),
)
</script>

<template>
  <section class="section bg-[var(--color-surface)]">
    <div class="container-app">
      <!-- Заголовок секции -->
      <div class="mb-10 max-w-2xl">
        <p class="eyebrow">{{ eyebrow || 'Что мы делаем' }}</p>
        <h2 class="section-title mt-3">
          {{ title || 'Услуги' }}
        </h2>
        <p v-if="description" class="mt-4 text-[var(--color-ink-muted)]">
          {{ description }}
        </p>
      </div>

      <!-- Сетка -->
      <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <NuxtLink
          v-for="(service, i) in services"
          :key="service.id"
          :to="`/services/${service.slug}`"
          class="group relative flex flex-col rounded-xl border border-[var(--color-line)] bg-[var(--color-surface)] p-7 transition-colors duration-300 hover:border-[var(--color-ink)]"
        >
          <!-- Номер + иконка -->
          <div class="mb-6 flex items-start justify-between">
            <span class="text-xs font-semibold tracking-[0.24em] text-[var(--color-ink-subtle)]">
              {{ String(i + 1).padStart(2, '0') }}
            </span>
            <span
              v-if="service.icon?.url"
              class="flex h-12 w-12 items-center justify-center overflow-hidden rounded-full border border-[var(--color-lime)] bg-[var(--color-lime)]/10"
            >
              <NuxtImg
                :src="service.icon.url"
                :alt="service.icon.alt || service.title"
                class="h-6 w-6 object-contain transition-transform duration-300 group-hover:scale-110"
                sizes="48px"
                format="webp"
              />
            </span>
          </div>

          <h3 class="mb-3 text-xl font-bold tracking-[-0.01em] text-[var(--color-ink)]">
            {{ service.title }}
          </h3>
          <p class="mb-8 text-sm leading-relaxed text-[var(--color-ink-muted)]">
            {{ service.shortDescription }}
          </p>

          <!-- Стрелка-CTA -->
          <span class="mt-auto inline-flex items-center gap-1.5 text-sm font-medium text-[var(--color-ink)] underline decoration-[var(--color-line)] decoration-1 underline-offset-4 transition-colors duration-200 group-hover:decoration-[var(--color-ink)]">
            Подробнее
            <UIcon name="i-lucide-arrow-right" class="h-4 w-4" aria-hidden="true" />
          </span>
        </NuxtLink>
      </div>
    </div>
  </section>
</template>
