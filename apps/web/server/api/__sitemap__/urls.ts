/**
 * Динамический source для @nuxtjs/sitemap.
 * Тянем все опубликованные страницы/проекты/услуги/статьи из Payload
 * и отдаём их URL-ы для sitemap.xml.
 *
 * defineSitemapEventHandler и asSitemapUrl — auto-imported модулем
 * @nuxtjs/sitemap в Nitro server routes. Явный импорт не нужен.
 */

interface PayloadDoc {
  slug: string
  updatedAt?: string
}
interface PayloadListResponse {
  docs: PayloadDoc[]
}

export default defineSitemapEventHandler(async () => {
  const base = useRuntimeConfig().public.payloadApiUrl as string

  // Параллельно забираем все типы контента
  const [pages, projects, services, posts] = await Promise.all([
    $fetch<PayloadListResponse>(`${base}/api/pages`, {
      query: { where: JSON.stringify({ _status: { equals: 'published' } }), limit: 100 },
    }).catch(() => ({ docs: [] })),
    $fetch<PayloadListResponse>(`${base}/api/projects`, {
      query: { where: JSON.stringify({ _status: { equals: 'published' } }), limit: 200 },
    }).catch(() => ({ docs: [] })),
    $fetch<PayloadListResponse>(`${base}/api/services`, {
      query: { where: JSON.stringify({ _status: { equals: 'published' } }), limit: 50 },
    }).catch(() => ({ docs: [] })),
    $fetch<PayloadListResponse>(`${base}/api/posts`, {
      query: { where: JSON.stringify({ _status: { equals: 'published' } }), limit: 200 },
    }).catch(() => ({ docs: [] })),
  ])

  const urls: ReturnType<typeof asSitemapUrl>[] = []

  // Главная (slug = 'home' → корень)
  for (const p of pages.docs.filter((p) => p.slug !== 'home')) {
    urls.push(asSitemapUrl({ loc: `/${p.slug}`, lastmod: p.updatedAt }))
  }
  for (const p of projects.docs) {
    urls.push(asSitemapUrl({ loc: `/portfolio/${p.slug}`, lastmod: p.updatedAt }))
  }
  for (const s of services.docs) {
    urls.push(asSitemapUrl({ loc: `/services/${s.slug}`, lastmod: s.updatedAt }))
  }
  for (const p of posts.docs) {
    urls.push(asSitemapUrl({ loc: `/blog/${p.slug}`, lastmod: p.updatedAt }))
  }

  return urls
})
