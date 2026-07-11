import type { Project, ProjectsResponse } from '@shared/types/payload'

/**
 * Список проектов (портфолио) с фильтрами.
 * Используется на /portfolio и в блоках «Избранные проекты».
 */
export function useProjects(options: {
  limit?: number
  featured?: boolean
  category?: string
  page?: number
} = {}) {
  const { limit = 12, featured, category, page = 1 } = options

  const where: Record<string, any> = {
    _status: { equals: 'published' },
  }
  if (featured) where.featured = { equals: true }
  if (category) where['categories.slug'] = { equals: category }

  return usePayload<ProjectsResponse>('projects', {
    where: payloadWhere(where),
    limit: String(limit),
    page: String(page),
    sort: '-featured,-updatedAt',
    depth: '2',
  })
}

/**
 * Один проект по slug — для страницы кейса /portfolio/[slug].
 */
export function useProject(slug: string) {
  return usePayload<{ docs: Project[]; totalDocs: number }>('projects', {
    where: payloadWhere({
      slug: { equals: slug },
      _status: { equals: 'published' },
    }),
    limit: '1',
    depth: '3',
  })
}
