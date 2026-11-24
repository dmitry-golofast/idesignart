/**
 * Разовая миграция данных (2026-10-23): посты перешли с поля category
 * (одиночная связь) на categories (hasMany, как у проектов), а теги стали
 * отдельной коллекцией tags (раньше указывали на categories).
 *
 * Что делает:
 *   1. Создаёт теги «Квартиры», «Коммерческие» в новой коллекции tags.
 *   2. Проставляет постам categories и tags по снимку старых данных:
 *      пост 2: categories=[Квартиры], tags=[Квартиры, Коммерческие]
 *      пост 3: categories=[Квартиры], tags=[Коммерческие]
 *   3. Чистит хвостовые строки posts_rels (path='tags' со старой
 *      ссылкой на categories) — через SQL, Local API их не видит.
 *
 * Запуск (payload run молчит на таких скриптах — tsx напрямую):
 *   node ../../node_modules/.pnpm/tsx@4.22.4/node_modules/tsx/dist/cli.mjs src/scripts/migrate-post-categories-tags.ts
 */
import { getPayload } from 'payload'
import payloadConfig from '../payload.config'

// Снимок старых данных (сняты до смены схемы):
// posts: id2 category=1, id3 category=1
// posts_rels(path='tags'): 2→[1,3], 3→[3]   (id категорий)
const SNAPSHOT = {
  posts: [
    { id: 2, categoryIds: [1], tagCategoryIds: [1, 3] },
    { id: 3, categoryIds: [1], tagCategoryIds: [3] },
  ],
  // id категории → тег для создания в коллекции tags
  tagSeeds: [
    { id: 1, title: 'Квартиры', slug: 'kvartiry' },
    { id: 3, title: 'Коммерческие', slug: 'kommerskie' },
  ],
} as const

async function main() {
  const payload = await getPayload({ config: payloadConfig })

  // 1. Теги (идемпотентно по slug)
  const tagIdByOldCat = new Map<number, string | number>()
  for (const seed of SNAPSHOT.tagSeeds) {
    const existing = await payload.find({ collection: 'tags', where: { slug: { equals: seed.slug } }, limit: 1 })
    const tag =
      existing.docs[0] ??
      (await payload.create({ collection: 'tags', data: { title: seed.title, slug: seed.slug } }))
    tagIdByOldCat.set(seed.id, tag.id)
    console.log(`тег «${seed.title}» → id=${tag.id}`)
  }

  // 2. Категории и теги постов
  for (const p of SNAPSHOT.posts) {
    await payload.update({
      collection: 'posts',
      id: p.id,
      data: {
        categories: p.categoryIds,
        tags: p.tagCategoryIds.map((c) => tagIdByOldCat.get(c)!),
      },
    })
    console.log(`пост id=${p.id}: categories=${p.categoryIds}, tags пересозданы`)
  }

  // 3. Хвосты старых связей
  await payload.db.drizzle.execute(
    `DELETE FROM posts_rels WHERE path = 'tags' AND tags_id IS NULL`,
  )
  console.log('хвостовые строки posts_rels удалены')

  process.exit(0)
}

main().catch((err) => {
  console.error('[migrate] FAIL:', err?.data?.errors ?? err?.message ?? err)
  process.exit(1)
})
