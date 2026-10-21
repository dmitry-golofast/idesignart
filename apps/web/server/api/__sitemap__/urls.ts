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
  // Группа meta добавляется плагином @payloadcms/plugin-seo
  meta?: { noindex?: boolean | null }
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
  // noindex-страницы в sitemap не входят
  const indexable = <T extends PayloadDoc>(docs: T[]) => docs.filter((d) => !d.meta?.noindex)

  // Главная (slug = 'home' → корень)
  for (const p of indexable(pages.docs).filter((p) => p.slug !== 'home')) {
    urls.push(asSitemapUrl({ loc: `/${p.slug}`, lastmod: p.updatedAt }))
  }
  for (const p of indexable(projects.docs)) {
    urls.push(asSitemapUrl({ loc: `/portfolio/${p.slug}`, lastmod: p.updatedAt }))
  }
  for (const s of indexable(services.docs)) {
    urls.push(asSitemapUrl({ loc: `/services/${s.slug}`, lastmod: s.updatedAt }))
  }
  for (const p of indexable(posts.docs)) {
    urls.push(asSitemapUrl({ loc: `/blog/${p.slug}`, lastmod: p.updatedAt }))
  }

  return urls
})
