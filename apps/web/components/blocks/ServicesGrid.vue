<script setup lang="ts">
import { computed } from 'vue'

/**
 * ServicesGrid — сетка карточек услуг.
 * Референс: Maverick Frame — карточки с чёткими заголовками-результатами.
 *
 * Берёт услуги из Payload через useServices() либо принимает через props.
 */
interface Service {
  id: string
  title: string
  slug: string
  shortDescription?: string
  icon?: { url?: string; alt?: string } | null
}

const props = defineProps<{
  services?: Service[]
  title?: string
  eyebrow?: string
}>()

// Если услуги не переданы — тянем опубликованные featured
const { data } = useServices({ featuredOnly: !props.services?.length })
const services = computed(() => props.services?.length ? props.services : (data.value?.docs || []))
</script>

<template>
  <section class="section bg-[var(--color-surface)]">
    <div class="container-app">
      <!-- Заголовок секции -->
      <div class="mb-12 max-w-2xl">
        <p class="eyebrow">{{ eyebrow || 'Что мы делаем' }}</p>
        <h2 class="mt-3 font-display text-[var(--text-h2)]">
          {{ title || 'Услуги' }}
        </h2>
      </div>

      <!-- Сетка -->
      <div class="grid gap-px overflow-hidden rounded-[var(--radius-lg)] bg-[var(--color-line)] sm:grid-cols-2 lg:grid-cols-3">
        <NuxtLink
          v-for="service in services"
          :key="service.id"
          :to="`/services/${service.slug}`"
          class="group relative flex flex-col bg-[var(--color-surface)] p-8 transition-all duration-[var(--duration-base)] ease-[var(--ease-premium)] hover:bg-[var(--color-surface-alt)]"
        >
          <!-- Иконка / мини-рендер -->
          <div v-if="service.icon?.url" class="mb-6 h-14 w-14 overflow-hidden rounded-[var(--radius-md)]">
            <NuxtImg
              :src="service.icon.url"
              :alt="service.icon.alt || service.title"
              class="h-full w-full object-cover transition-transform duration-[var(--duration-slow)] group-hover:scale-110"
              sizes="56px"
              format="webp"
            />
          </div>

          <h3 class="mb-3 font-display text-[var(--text-h3)] text-[var(--color-ink)]">
            {{ service.title }}
          </h3>
          <p class="mb-6 text-sm leading-relaxed text-[var(--color-ink-muted)]">
            {{ service.shortDescription }}
          </p>

          <!-- Стрелка-CTA -->
          <span class="link-arrow mt-auto text-sm" :aria-label="`Подробнее: ${service.title}`">
            Подробнее
          </span>
        </NuxtLink>
      </div>
    </div>
  </section>
</template>
