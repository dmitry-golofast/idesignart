/**
 * Страница «О студии» (slug=about) с блоком about-hero: текст слева,
 * фото справа, под фото — цитата основателя. Фото берём из медиатеки
 * (свежая загрузка) как заглушку — заменяется в админке.
 *
 * Идемпотентен: если страница about уже есть — не трогает.
 *
 * Запуск: pnpm --filter payload exec payload run ./src/scripts/seed-about.ts
 */
import { getPayload } from 'payload'
import payloadConfig from '../payload.config'

async function main() {
  console.log('[seed-about] старт')
  const payload = await getPayload({ config: payloadConfig })

  const existing = await payload.find({
    collection: 'pages',
    where: { slug: { equals: 'about' } },
    limit: 1,
    depth: 0,
  })
  if (existing.docs[0]) {
    payload.logger.info(`Страница /about уже существует (id=${existing.docs[0].id}) — не трогаем`)
    return
  }

  // Фото-заглушка: свежая загрузка медиатеки (интерьеры студии)
  const media = await payload.find({ collection: 'media', sort: '-createdAt', limit: 1, depth: 0 })
  const photoId = media.docs[0]?.id ?? null

  const page = await payload.create({
    collection: 'pages',
    draft: false,
    data: {
      title: 'О студии',
      slug: 'about',
      sections: [
        {
          blockType: 'about-hero',
          title: 'Создаём пространства, в которых хочется жить и работать',
          description:
            'idesignart — студия дизайна интерьера и 3D-визуализации. Мы проектируем квартиры, дома и общественные пространства, объединяя эстетику и функциональность.',
          photo: photoId,
          photoAlt: 'Интерьер, созданный студией idesignart',
          quote:
            'Хороший интерьер незаметен: он просто делает жизнь удобнее. Мы проектируем именно так — от сценариев дня до последнего выключателя.',
          quoteAuthor: 'Основатель студии',
          quoteRole: 'idesignart',
        },
      ],
      meta: {
        title: 'О студии — idesignart',
        description: 'Студия дизайна интерьера и 3D-визуализации. Команда, подход, ценности.',
      },
      _status: 'published',
    },
  })
  payload.logger.info(`Страница /about создана (id=${page.id}, photo=${String(photoId)})`)
  payload.logger.info('✅ Страница «О студии» готова')
}

await main().catch((err) => {
  console.error('Ошибка seed:', err)
  process.exit(1)
})
