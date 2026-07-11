<script setup lang="ts">
/**
 * PageSections — рендерит массив блоков страницы из Payload.
 * Мапит blockType (slug блока из Payload) на Vue-компонент.
 *
 * resolveComponent обязателен — <component :is="'StringName'"> не работает
 * в SSR без явного резолва.
 */

interface PageSection {
  id: string
  blockType: string
  [key: string]: any
}

const props = defineProps<{
  sections: PageSection[]
}>()

// Резолвим компоненты один раз (Nuxt auto-import)
// Имена соответствуют структуре: components/blocks/HeroSection.vue → BlocksHeroSection
const HeroSection = resolveComponent('BlocksHeroSection')
const StatsSection = resolveComponent('BlocksStatsSection')
const ServicesGrid = resolveComponent('BlocksServicesGrid')
const PortfolioMasonry = resolveComponent('BlocksPortfolioMasonry')
const ProcessSteps = resolveComponent('BlocksProcessSteps')
const PricingCalculator = resolveComponent('BlocksPricingCalculator')
const TestimonialsSection = resolveComponent('BlocksTestimonialsSection')
const ContentSection = resolveComponent('BlocksContentSection')
const CtaBanner = resolveComponent('BlocksCtaBanner')
const ContactForm = resolveComponent('BlocksContactForm')

const blockMap: Record<string, any> = {
  hero: HeroSection,
  stats: StatsSection,
  'services-grid': ServicesGrid,
  'portfolio-grid': PortfolioMasonry,
  'process-steps': ProcessSteps,
  'pricing-calculator': PricingCalculator,
  testimonials: TestimonialsSection,
  content: ContentSection,
  'cta-banner': CtaBanner,
  'contact-form': ContactForm,
}

const isDev = import.meta.dev
</script>

<template>
  <template v-for="section in sections" :key="section.id">
    <component
      :is="blockMap[section.blockType]"
      v-bind="section"
    />
    <!-- Dev-предупреждение для неизвестного блока -->
    <div
      v-if="!blockMap[section.blockType] && isDev"
      class="container-app py-8 text-center text-[var(--color-error)]"
    >
      ⚠️ Неизвестный блок: «{{ section.blockType }}»
    </div>
  </template>
</template>
