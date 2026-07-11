import tailwindcss from '@tailwindcss/vite'

export default defineNuxtConfig({
  compatibilityDate: '2025-01-01',
  devtools: { enabled: true },

  modules: [
    '@nuxt/image',
    '@nuxt/ui',
    '@vueuse/nuxt',
    '@pinia/nuxt',
    '@nuxtjs/sitemap',
    '@nuxtjs/robots',
    'nuxt-schema-org',
  ],

  // ===== App =====
  app: {
    head: {
      htmlAttrs: { lang: 'ru' },
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      ],
      link: [{ rel: 'icon', type: 'image/svg+xml', href: '/favicon.svg' }],
    },
    pageTransition: { name: 'page', mode: 'out-in' },
  },

  // ===== Цветовая схема (Nuxt UI) =====
  colorMode: {
    preference: 'light',
    fallback: 'light',
  },

  // ===== Tailwind v4 через Vite-плагин =====
  css: ['~/assets/css/main.css'],
  vite: {
    plugins: [tailwindcss()],
  },

  // ===== Runtime config (env → public) =====
  runtimeConfig: {
    // server-only
    payloadApiUrl: process.env.PAYLOAD_API_URL || 'http://localhost:3001',
    payloadSecret: process.env.PAYLOAD_SECRET || '',
    public: {
      payloadApiUrl: process.env.NUXT_PUBLIC_PAYLOAD_API_URL || 'http://localhost:3001',
      siteUrl: process.env.NUXT_PUBLIC_SITE_URL || 'http://localhost:3000',
      gaId: process.env.NUXT_PUBLIC_GA_ID || '',
      yandexMetrikaId: process.env.NUXT_PUBLIC_YANDEX_METRIKA_ID || '',
      plausibleDomain: process.env.NUXT_PUBLIC_PLAUSIBLE_DOMAIN || '',
      whatsapp: process.env.NUXT_PUBLIC_WHATSAPP || '',
      telegram: process.env.NUXT_PUBLIC_TELEGRAM || '',
      phone: process.env.NUXT_PUBLIC_PHONE || '',
      email: process.env.NUXT_PUBLIC_EMAIL || 'hello@idesignart.com',
    },
  },

  // ===== SEO =====
  site: {
    url: process.env.NUXT_PUBLIC_SITE_URL || 'http://localhost:3000',
    name: 'idesignart',
  },
  sitemap: {
    // Динамические маршруты подтягиваются из sources
    sources: ['/api/__sitemap__/urls'],
  },
  robots: {
    // По умолчанию разрешаем, точные правила — в robots.config
    allow: '/',
  },

  // ===== Редиректы =====
  // /admin и /api (CMS) → на Payload сервер (Next.js :3001)
  // В dev: на localhost:3001, в проде — через env PAYLOAD_API_URL
  routeRules: {
    '/admin': {
      redirect: {
        to: process.env.NUXT_PUBLIC_PAYLOAD_API_URL + '/admin' || 'http://localhost:3001/admin',
        statusCode: 302,
      },
    },
    '/admin/**': {
      redirect: {
        to: process.env.NUXT_PUBLIC_PAYLOAD_API_URL + '/admin/**' || 'http://localhost:3001/admin/**',
        statusCode: 302,
      },
    },
  },

  // ===== Изображения =====
  image: {
    // Payload отдаёт /media/* — используем <NuxtImg> и <NuxtPicture>
    format: ['webp', 'avif'],
    quality: 82,
    screens: {
      xs: 320,
      sm: 640,
      md: 768,
      lg: 1024,
      xl: 1280,
      xxl: 1536,
      '2xl': 1920,
      '3xl': 2400,
    },
    domains: [process.env.NUXT_PUBLIC_PAYLOAD_API_URL || 'localhost:3001'],
  },

  // ===== TypeScript =====
  typescript: {
    strict: true,
    typeCheck: false, // включать через pnpm typecheck
  },

  // ===== Экспериментальные / nitro =====
  nitro: {
    compressPublicAssets: true,
    prerender: {
      // Статичных маршрутов нет — все динамические из Payload.
      // Можно добавить crawlLinks для SSG.
      crawlLinks: false,
    },
  },

  future: {
    compatibilityVersion: 4,
  },
})
