import type { Post } from '#shared/types/payload'
import type { PostsResponse } from '../shared/payload-helpers'
import { freshOnVisit, usePayload } from './usePayload'
import { populated } from '../utils/payload'

/**
 * Список статей блога с пагинацией.
 * category — фильтр по категории поста (slug из связи categories);
 * принимает реактивное значение: смена категории перезапрашивает
 * посты на месте, без перезагрузки страницы.
 */
export function usePosts(
  options: {
    limit?: number
    page?: number
    category?: string | Ref<string | undefined> | (() => string | undefined)
  } = {},
) {
  const { limit = 9, page = 1 } = options

  const query = computed<Record<string, string>>(() => {
    const where: Record<string, any> = {
      _status: { equals: 'published' },
    }
    const category = toValue(options.category)
    if (category) where['categories.slug'] = { equals: category }

    return {
      where: payloadWhere(where),
      limit: String(limit),
      page: String(page),
      sort: '-publishedAt',
    }
  })

  // Свежие данные при каждом заходе на страницу (не из кеша прошлого визита)
  return usePayload<PostsResponse>('posts', query, { getCachedData: freshOnVisit })
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

export interface BlogCategory {
  id: number
  title: string
  slug: string
  count: number
}

/**
 * Категории для фильтра на /blog: уникальные категории всех опубликованных
 * постов (те же категории, что у проектов), сортировка по частоте.
 * Запрос всегда без фильтра — чипы стабильны при выборе категории.
 */
export function usePostCategories() {
  const { data } = usePayload<{ docs: Post[] }>(
    'posts',
    {
      where: payloadWhere({ _status: { equals: 'published' } }),
      limit: '100',
      depth: '1',
    },
    // Чипы фильтра строятся из категорий постов: при редактировании постов
    // в админке состав чипов обновляется при следующем заходе на /blog
    { getCachedData: freshOnVisit },
  )

  const categories = computed<BlogCategory[]>(() => {
    const map = new Map<number, BlogCategory>()
    for (const post of data.value?.docs ?? []) {
      for (const rel of post.categories ?? []) {
        const c = populated(rel)
        if (!c) continue
        const cur = map.get(c.id)
        if (cur) cur.count++
        else map.set(c.id, { id: c.id, title: c.title, slug: c.slug, count: 1 })
      }
    }
    return [...map.values()].sort(
      (a, b) => b.count - a.count || a.title.localeCompare(b.title, 'ru'),
    )
  })

  return { data, categories }
}
