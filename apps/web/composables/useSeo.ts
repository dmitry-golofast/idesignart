import type { Media } from '../shared/types/payload'

/**
 * useSeo — единый хелпер для SEO-мета на каждой странице.
 *
 * Слои значений: страница → Settings.seoDefaults («SEO по умолчанию» в админке)
 * → builtin-фолбэк. Description из шаблона (%s) подставляется только когда у
 * страницы своего описания нет; в %s идёт title страницы.
 *
 * Note: useSeoMeta / useHead / useSchemaOrg / defineLocalBusiness /
 * useRuntimeConfig / useRoute — Nuxt auto-imports.
 */

// Поля из Payload могут быть null (seo-группа необязательна) — принимаем null,
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

/** Шаблон описания: %s заменяется на title страницы; без него разделитель подчищается */
const applyDescriptionTemplate = (template: string, fill?: string | null) => {
  if (!template.includes('%s')) return template
  const value = (fill ?? '').trim()
  if (!value) return template.replace('%s', '').replace(/\s*[—–-]\s*$/, '').trim()
  return template.replace('%s', value)
}

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

  // Дефолты из Settings (fetch дедуплицируется по ключу useAsyncData)
  const { data: settingsData } = useSettings()
  const seoDefaults = settingsData.value?.seoDefaults ?? {}

  // title: страница → глобальный дефолт
  const title = options.title || seoDefaults.title || undefined

  // description: страница → шаблон с %s из Settings
  const description = options.description
    ?? (seoDefaults.descriptionTemplate
      ? applyDescriptionTemplate(seoDefaults.descriptionTemplate, options.title)
      : null)

  // OG-картинка: страница → глобальная дефолтная → /og-default.jpg
  const defaultOgUrl = isMedia(seoDefaults.defaultOgImage)
    ? seoDefaults.defaultOgImage.url ?? null
    : null
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

  // Canonical + коды верификации поисковиков (заполняются в админке, Settings → SEO)
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
