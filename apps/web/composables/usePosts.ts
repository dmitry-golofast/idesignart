import type { Post, PostsResponse } from '@shared/types/payload'

/**
 * Список статей блога с пагинацией.
 */
export function usePosts(options: { limit?: number; page?: number; category?: string } = {}) {
  const { limit = 9, page = 1, category } = options

  const where: Record<string, any> = {
    _status: { equals: 'published' },
  }
  if (category) where['category.slug'] = { equals: category }

  return usePayload<PostsResponse>('posts', {
    where: payloadWhere(where),
    limit: String(limit),
    page: String(page),
    sort: '-publishedAt',
    depth: '2',
  })
}

/**
 * Одна статья по slug.
 */
export function usePost(slug: string) {
  return usePayload<{ docs: Post[]; totalDocs: number }>('posts', {
    where: payloadWhere({
      slug: { equals: slug },
      _status: { equals: 'published' },
    }),
    limit: '1',
    depth: '2',
  })
}
