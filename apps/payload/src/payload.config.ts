import { buildConfig, type SharpDependency } from 'payload'
import { postgresAdapter } from '@payloadcms/db-postgres'
import { lexicalEditor } from '@payloadcms/richtext-lexical'
import { seoPlugin } from '@payloadcms/plugin-seo'
import type {
  GenerateDescription,
  GenerateImage,
  GenerateTitle,
  GenerateURL,
} from '@payloadcms/plugin-seo/types'
import sharp from 'sharp'

import { Media } from './collections/Media'
import { Pages } from './collections/Pages'
import { Projects } from './collections/Projects'
import { Services } from './collections/Services'
import { Posts } from './collections/Posts'
import { Categories } from './collections/Categories'
import { Tags } from './collections/Tags'
import { Leads } from './collections/Leads'
import { Subscriptions } from './collections/Subscriptions'
import { Users } from './collections/Users'
import { Settings } from './globals/Settings'
import { Header } from './globals/Header'

// Same-origin: админка и API доступны на origin сайта (в dev — через
// прокси в Nuxt на :3000, в проде — через Caddy). Явно переопределяется
// PAYLOAD_PUBLIC_SERVER_URL (prod задаёт его в docker-compose).
const appURL = process.env.PAYLOAD_PUBLIC_SERVER_URL || 'http://localhost:3000'
const secret = process.env.PAYLOAD_SECRET || 'idesignart-dev-secret-key-2026-change-in-prod'

// В dev standalone-вызов getPayload() (сид- и миграционные скрипты, payload run)
// открывает HMR-WebSocket к ws://localhost:${PORT || 3000}/_next/webpack-hmr —
// предполагая, что админка Next слушает :3000. Здесь на :3000 стоит Nuxt: сокет
// попадает в заглушку web/server/routes/_next/webpack-hmr.ts, а его обрыв при
// выходе скрипта даёт в Nuxt unhandledRejection (read ECONNRESET) → рестарт или
// зависание dev-сервера. Направляем на настоящий HMR админки на :3001.
if (process.env.NODE_ENV !== 'production') {
  process.env.PAYLOAD_HMR_URL_OVERRIDE ??= 'ws://localhost:3001/_next/webpack-hmr'
}

// ===== SEO (@payloadcms/plugin-seo) =====
// Плагин добавляет группу meta (title/description/image/noindex)
// с превью сниппета Google и счётчиками длины в админке — на страницы
// четырёх коллекций и в global «settings» (дефолтные значения сайта).
const seoSiteUrl = process.env.NUXT_PUBLIC_SITE_URL || appURL

// Превью-ссылка: URL страницы на сайте по слагу коллекции
const seoPaths: Record<string, (doc: { slug?: string }) => string> = {
  pages: (doc) => (doc.slug === 'home' ? '/' : `/${doc.slug}`),
  posts: (doc) => `/blog/${doc.slug}`,
  projects: (doc) => `/portfolio/${doc.slug}`,
  services: (doc) => `/services/${doc.slug}`,
}

const seoGenerateURL: GenerateURL = ({ doc, collectionSlug }) => {
  const buildPath = collectionSlug ? seoPaths[collectionSlug] : undefined
  const path = doc?.slug && buildPath ? buildPath(doc) : ''
  return path ? `${seoSiteUrl}${path}` : seoSiteUrl
}

// «Сгенерировать» в админке: подсказки на основе полей документа
const seoGenerateTitle: GenerateTitle = ({ doc }) =>
  doc?.title ? `${doc.title} — idesignart` : ''

const seoGenerateDescription: GenerateDescription = ({ doc }) =>
  doc?.excerpt || doc?.shortDescription || ''

const seoGenerateImage: GenerateImage = ({ doc }) =>
  doc?.coverImage?.id ?? doc?.coverImage ?? doc?.heroImage ?? ''

export default buildConfig({
  secret,
  serverURL: appURL,
  admin: {
    user: Users.slug,
    // Админка доступна на /admin (путь по умолчанию)
  },
  routes: {
    api: '/api',
  },
  collections: [
    Media,
    Pages,
    Projects,
    Services,
    Posts,
    Categories,
    Tags,
    Leads,
    Subscriptions,
    Users,
  ],
  globals: [Settings, Header],
  plugins: [
    seoPlugin({
      collections: ['pages', 'posts', 'projects', 'services'],
      // Дефолтные title/description/OG-картинка сайта — в global «settings»
      globals: ['settings'],
      uploadsCollection: 'media',
      generateURL: seoGenerateURL,
      generateTitle: seoGenerateTitle,
      generateDescription: seoGenerateDescription,
      generateImage: seoGenerateImage,
      // noindex в плагине нет — добавляем в ту же группу meta
      // (в старых seo-группах pages/posts чекбокс уже был)
      fields: ({ defaultFields }) => [
        ...defaultFields,
        {
          name: 'noindex',
          type: 'checkbox',
          label: 'Скрыть из индексации (noindex)',
          defaultValue: false,
        },
      ],
    }),
  ],
  editor: lexicalEditor(),
  db: postgresAdapter({
    pool: {
      connectionString:
        process.env.DATABASE_URI ||
        'postgresql://postgres:postgres@localhost:5432/idesignart',
    },
  }),
  // Типы sharp в дереве (0.33) структурно расходятся с теми, на которые
  // ссылается SharpDependency payload'а (0.32/0.34 в сторе) — рантайм совместим
  sharp: sharp as unknown as SharpDependency,
  typescript: {
    // Путь от корня apps/payload (cwd при запуске payload CLI).
    // Корневой скрипт generate:types копирует файл в web/shared/types/ —
    // фронтенд импортирует его через #shared/types/payload
    outputFile: 'types/payload.ts',
  },
  // Сайт и Payload same-origin на всех окружениях: админка и API доступны
  // на /admin и /api основного origin (в dev — через прокси в Nuxt, в
  // проде — через Caddy). CORS/CSRF-list остаётся для совместимости и
  // прямого доступа к :3001 в dev: без :3001 в csrf админка, открытая
  // напрямую на :3001, читает данные, но любой POST/PATCH/DELETE уходит
  // без сессии и получает 403.
  cors: [
    process.env.NUXT_PUBLIC_SITE_URL || 'http://localhost:3000',
    'http://localhost:3000',
    'http://localhost:3001',
  ],
  csrf: [
    process.env.NUXT_PUBLIC_SITE_URL || 'http://localhost:3000',
    'http://localhost:3000',
    'http://localhost:3001',
  ],
})
