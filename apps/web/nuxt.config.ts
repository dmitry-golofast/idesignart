import tailwindcss from '@tailwindcss/vite'

export default defineNuxtConfig({
  compatibilityDate: '2025-01-01',
  devtools: { enabled: true },

  modules: [
    '@nuxt/image',
    '@nuxt/ui',
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
      link: [
        { rel: 'icon', type: 'image/svg+xml', href: '/favicon.svg' },
        // Шрифты с кириллицей: Inter — основной sans сайта и дефолт hero,
        // Manrope — альтернатива из настроек оформления hero (§08 спеки)
        { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
        { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' },
        {
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Inter:wght@100..900&family=Manrope:wght@200..800&display=swap',
        },
      ],
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

  // ===== Runtime config =====
  // payloadProxyTarget — куда server/middleware/payload-proxy.ts проксирует
  // пути Payload (пустая строка отключает прокси).
  runtimeConfig: {
    payloadProxyTarget: process.env.PAYLOAD_PROXY_TARGET || 'http://localhost:3001',
    public: {
      // Same-origin: в dev Payload-пути проксируются через этот же сервер
      payloadApiUrl: process.env.NUXT_PUBLIC_PAYLOAD_API_URL || 'http://localhost:3000',
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

  // ===== Роутинг /admin, /api и прочих путей Payload =====
  // Админка и API same-origin на любом окружении: в dev их проксирует
  // server/middleware/payload-proxy.ts на админ-сервер (:3001), в проде —
  // Caddy (@payload matcher) на контейнер admin. Отдельных редиректов
  // здесь быть не должно (см. коммит 918121a про self-redirect loop).

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
    domains: [process.env.NUXT_PUBLIC_PAYLOAD_API_URL || 'localhost:3000'],
  },

  // ===== TypeScript =====
  typescript: {
    strict: true,
    typeCheck: false, // включать через pnpm typecheck
    // Сгенерированные типы Payload лежат в shared/types/payload.ts
    // и импортируются через нативный алиас #shared/types/payload
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
