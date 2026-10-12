/**
 * app.config.ts — runtime-конфигурация Nuxt UI.
 * Мапим UI-токены на нашу дизайн-систему.
 */
export default defineAppConfig({
  ui: {
    colors: {
      primary: 'lime',     // фирменный лайм: слайдеры, фокусы инпутов, мелкая UI-статика
      neutral: 'stone',    // тёплый нейтрал
    },
    buttons: {
      defaultVariants: {
        size: 'md',
      },
      slots: {
        base: 'font-medium rounded-[var(--radius-md)] transition-all duration-[var(--duration-base)] ease-[var(--ease-premium)]',
      },
    },
  },
})
