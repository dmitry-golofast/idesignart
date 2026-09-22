import { buildConfig, type SharpDependency } from 'payload'
import { postgresAdapter } from '@payloadcms/db-postgres'
import { lexicalEditor } from '@payloadcms/richtext-lexical'
import sharp from 'sharp'

import { Media } from './collections/Media'
import { Pages } from './collections/Pages'
import { Projects } from './collections/Projects'
import { Services } from './collections/Services'
import { Posts } from './collections/Posts'
import { Categories } from './collections/Categories'
import { Leads } from './collections/Leads'
import { Subscriptions } from './collections/Subscriptions'
import { Users } from './collections/Users'
import { Settings } from './globals/Settings'

const appURL = process.env.PAYLOAD_PUBLIC_SERVER_URL || 'http://localhost:3001'
const secret = process.env.PAYLOAD_SECRET || 'idesignart-dev-secret-key-2026-change-in-prod'

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
    Leads,
    Subscriptions,
    Users,
  ],
  globals: [Settings],
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
  // Сайт и Payload теперь same-origin (админка на /admin основного домена):
  // cross-origin остаётся только в dev (web :3000 → payload :3001)
  cors: [
    process.env.NUXT_PUBLIC_SITE_URL || 'http://localhost:3000',
    'http://localhost:3000',
  ],
  csrf: [
    process.env.NUXT_PUBLIC_SITE_URL || 'http://localhost:3000',
    'http://localhost:3000',
  ],
})
