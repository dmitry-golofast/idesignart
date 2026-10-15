<script setup lang="ts">
/**
 * PageSections — рендерит массив блоков страницы из Payload.
 * Мапит blockType (slug блока из Payload) на Vue-компонент.
 *
 * Главам (блокам с editorial-номером) номер присваивается по фактическому
 * порядку на странице: «01», «02», … — независимо от состава блоков в CMS.
 *
 * resolveComponent обязателен — <component :is="'StringName'"> не работает
 * в SSR без явного резолва.
 */

interface PageSection {
  id?: string | null
  blockType: string
  [key: string]: any
}

const props = defineProps<{
  sections: PageSection[]
}>()

// Блоки-«главы» с номером в шапке (порядок в этом списке не важен —
// номер считается по порядку следования на странице)
const CHAPTER_BLOCKS = new Set([
  'services-grid',
  'portfolio-grid',
  'process-steps',
  'testimonials',
])

/** Номер главы для конкретной секции — по порядку следования на странице */
function chapterNum(s: PageSection): number | undefined {
  if (!CHAPTER_BLOCKS.has(s.blockType)) return undefined
  let n = 0
  for (const x of props.sections) {
    if (!CHAPTER_BLOCKS.has(x.blockType)) continue
    n++
    if (x.blockType === s.blockType && x.id === s.id) return n
  }
  return undefined
}

// Резолвим компоненты один раз (Nuxt auto-import)
// Имена соответствуют структуре: components/blocks/HeroSection.vue → BlocksHeroSection
const HeroSection = resolveComponent('BlocksHeroSection')
const ServicesGrid = resolveComponent('BlocksServicesGrid')
const PortfolioMasonry = resolveComponent('BlocksPortfolioMasonry')
const ProcessSteps = resolveComponent('BlocksProcessSteps')
const TestimonialsSection = resolveComponent('BlocksTestimonialsSection')
const ContentSection = resolveComponent('BlocksContentSection')
const CtaBanner = resolveComponent('BlocksCtaBanner')
const ContactForm = resolveComponent('BlocksContactForm')

const blockMap: Record<string, any> = {
  hero: HeroSection,
  'services-grid': ServicesGrid,
  'portfolio-grid': PortfolioMasonry,
  'process-steps': ProcessSteps,
  testimonials: TestimonialsSection,
  content: ContentSection,
  'cta-banner': CtaBanner,
  'contact-form': ContactForm,
}

const isDev = import.meta.dev
</script>

<template>
  <!-- Каждому блоку — якорь по blockType (#portfolio-grid, #contact-form, …);
       scroll-mt компенсирует sticky-шапку при хеш-навигации -->
  <div
    v-for="(section, i) in sections"
    :id="section.blockType"
    :key="section.id ?? `${section.blockType}-${i}`"
    class="scroll-mt-24"
  >
    <component
      :is="blockMap[section.blockType]"
      v-bind="section"
      :num="chapterNum(section)"
    />
    <!-- Dev-предупреждение для неизвестного блока -->
    <div
      v-if="!blockMap[section.blockType] && isDev"
      class="container-app py-8 text-center text-[var(--color-error)]"
    >
      ⚠️ Неизвестный блок: «{{ section.blockType }}»
    </div>
  </div>
</template>
