import type { Media } from '../shared/types/payload'

/**
 * useSeo — единый хелпер для SEO-мета на каждой странице.
 *
 * Слои значений: страница (meta от @payloadcms/plugin-seo) → global «settings»
 * (meta — дефолты сайта, тот же плагин; seoDefaults — коды верификации)
 * → builtin-фолбэк.
 *
 * Note: useSeoMeta / useHead / useSchemaOrg / defineLocalBusiness /
 * useRuntimeConfig / useRoute — Nuxt auto-imports.
 */

// Поля из Payload могут быть null (meta-группа необязательна) — принимаем null,
// чтобы страницы не приходило чистить перед вызовом
interface SeoOptions {
  title?: string | null
  description?: string | null
  image?: string | null
  url?: string
  noindex?: boolean
  type?: 'website' | 'article' | 'profile'
  keywords?: string | null
  publishedTime?: string | null
  modifiedTime?: string | null
  author?: string | null
}

const isMedia = (m: unknown): m is Media =>
  Boolean(m) && typeof m === 'object' && typeof (m as Media).url === 'string'

/**
 * useSeo — единый хелпер для SEO-мета на каждой странице.
 *
 * Использование:
 *   useSeo({ title: 'Дизайн квартиры', description: '...' })
 */
export function useSeo(options: SeoOptions = {}) {
  const config = useRuntimeConfig()
  const siteUrl = config.public.siteUrl as string
  const payloadBase = config.public.payloadApiUrl as string
  const route = useRoute()

  // Дефолты из Settings (fetch дедуплицируется по ключу useAsyncData).
  // meta — дефолтные title/description/OG-картинка сайта (seoPlugin);
  // seoDefaults — только коды верификации поисковиков.
  const { data: settingsData } = useSettings()
  const settings = settingsData.value
  const siteMeta = settings?.meta ?? {}
  const seoDefaults = settings?.seoDefaults ?? {}

  // title: страница → дефолт сайта
  const title = options.title || siteMeta.title || undefined

  // description: страница → дефолт сайта
  const description = options.description || siteMeta.description || null

  // OG-картинка: страница → дефолтная сайта → /og-default.jpg
  const defaultOgUrl = isMedia(siteMeta.image) ? siteMeta.image.url ?? null : null
  const imageUrl = options.image || defaultOgUrl || '/og-default.jpg'
  // /media/* отдаёт Payload, /og-default.jpg лежит в public/ фронтенда
  const fullImage = imageUrl.startsWith('http')
    ? imageUrl
    : imageUrl.startsWith('/media/')
      ? `${payloadBase}${imageUrl}`
      : `${siteUrl}${imageUrl}`

  const fullUrl = options.url || `${siteUrl}${route.path}`

  const meta: Record<string, any> = {
    title,
    description,
    keywords: options.keywords,
    ogTitle: title,
    ogDescription: description,
    ogImage: fullImage,
    ogUrl: fullUrl,
    ogType: options.type || 'website',
    ogSiteName: 'idesignart',
    twitterCard: 'summary_large_image',
    twitterTitle: title,
    twitterDescription: description,
    twitterImage: fullImage,
  }

  if (options.noindex) {
    meta.robots = 'noindex, nofollow'
  }
  if (options.type === 'article') {
    meta.articlePublishedTime = options.publishedTime
    meta.articleModifiedTime = options.modifiedTime
    meta.articleAuthor = options.author
  }

  useSeoMeta(meta)

  // Canonical + коды верификации поисковиков (заполняются в админке, Settings → Верификация)
  useHead({
    link: [{ rel: 'canonical', href: fullUrl }],
    meta: [
      ...(seoDefaults.googleVerification
        ? [{ name: 'google-site-verification', content: seoDefaults.googleVerification }]
        : []),
      ...(seoDefaults.yandexVerification
        ? [{ name: 'yandex-verification', content: seoDefaults.yandexVerification }]
        : []),
    ],
  })

  // JSON-LD LocalBusiness — глобальный, на каждой странице
  useSchemaOrg([
    defineLocalBusiness({
      name: 'idesignart',
      description: 'Студия дизайна интерьера и 3D-визуализации',
      url: siteUrl,
      image: fullImage,
      email: config.public.email as string,
      telephone: config.public.phone as string,
      address: {
        addressCountry: 'RU',
      },
    }),
  ])
}
