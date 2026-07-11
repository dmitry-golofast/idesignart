import type { Service, ServicesResponse } from '@shared/types/payload'

/**
 * Список всех услуг (для сетки на /services и блока на главной).
 */
export function useServices(options: { featuredOnly?: boolean } = {}) {
  const where: Record<string, any> = {
    _status: { equals: 'published' },
  }
  if (options.featuredOnly) where.featured = { equals: true }

  return usePayload<ServicesResponse>('services', {
    where: payloadWhere(where),
    sort: 'order',
    limit: '20',
    depth: '2',
  })
}

/**
 * Одна услуга по slug — для посадочной /services/[slug].
 */
export function useService(slug: string) {
  return usePayload<{ docs: Service[]; totalDocs: number }>('services', {
    where: payloadWhere({
      slug: { equals: slug },
      _status: { equals: 'published' },
    }),
    limit: '1',
    depth: '3',
  })
}
