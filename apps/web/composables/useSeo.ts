/**
 * useSeo — единый хелпер для SEO-мета на каждой странице.
 * Склеивает с дефолтами из Settings, формирует Open Graph + Twitter Card.
 *
 * Note: useSeoMeta / useHead / useSchemaOrg / defineLocalBusiness /
 * useRuntimeConfig / useRoute — Nuxt auto-imports.
 */

interface SeoOptions {
  title?: string
  description?: string
  image?: string
  url?: string
  noindex?: boolean
  type?: 'website' | 'article' | 'profile'
  keywords?: string
  publishedTime?: string
  modifiedTime?: string
  author?: string
}

/**
 * useSeo — единый хелпер для SEO-мета на каждой странице.
 * Склеивает с дефолтами из Settings, формирует Open Graph + Twitter Card.
 *
 * Использование:
 *   useSeo({ title: 'Дизайн квартиры', description: '...' })
 */
export function useSeo(options: SeoOptions = {}) {
  const config = useRuntimeConfig()
  const siteUrl = config.public.siteUrl as string
  const route = useRoute()

  const fullUrl = options.url || `${siteUrl}${route.path}`
  const fullImage = options.image?.startsWith('http')
    ? options.image
    : options.image
      ? `${siteUrl}${options.image}`
      : `${siteUrl}/og-default.jpg`

  const meta: Record<string, any> = {
    title: options.title,
    description: options.description,
    keywords: options.keywords,
    ogTitle: options.title,
    ogDescription: options.description,
    ogImage: fullImage,
    ogUrl: fullUrl,
    ogType: options.type || 'website',
    ogSiteName: 'idesignart',
    twitterCard: 'summary_large_image',
    twitterTitle: options.title,
    twitterDescription: options.description,
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

  // Canonical
  useHead({
    link: [{ rel: 'canonical', href: fullUrl }],
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
