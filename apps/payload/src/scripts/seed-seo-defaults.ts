/**
 * Разовое наполнение Settings → seoDefaults («SEO по умолчанию» в админке):
 * стартовый title, шаблон описания и дефолтная OG-картинка.
 *
 * Идемпотентно: непустые поля не перезаписывает — правки из админки не затирает.
 * Коды googleVerification/yandexVerification не трогает — их заполняет владелец.
 *
 * Запуск: pnpm --filter payload exec payload run ./src/scripts/seed-seo-defaults.ts
 */
import { getPayload } from 'payload'
import payloadConfig from '../payload.config'

async function main() {
  console.log('[seed-seo] старт')
  const payload = await getPayload({ config: payloadConfig })

  const settings = await payload.findGlobal({ slug: 'settings', depth: 0 })
  const current = settings.seoDefaults ?? {}

  // Дефолтная OG-картинка — то же фото, что и в hero (ищем по служебному title)
  let ogImageId: number | string | null = null
  if (isMedia(current.defaultOgImage)) {
    ogImageId = current.defaultOgImage.id
  } else {
    const media = await payload.find({
      collection: 'media',
      where: { title: { equals: 'Hero — тёплый минимализм' } },
      limit: 1,
      depth: 0,
    })
    ogImageId = media.docs[0]?.id ?? null
  }

  await payload.updateGlobal({
    slug: 'settings',
    data: {
      seoDefaults: {
        title: current.title || 'idesignart — студия дизайна интерьера и 3D-визуализации',
        descriptionTemplate:
          current.descriptionTemplate || '%s | idesignart — студия дизайна интерьера и 3D-визуализации',
        ...(ogImageId ? { defaultOgImage: ogImageId } : {}),
        googleVerification: current.googleVerification ?? null,
        yandexVerification: current.yandexVerification ?? null,
      },
    },
  })

  console.log('✅ Settings.seoDefaults заполнены стартовыми значениями')
}

function isMedia(m: unknown): m is { id: number } {
  return Boolean(m) && typeof m === 'object' && typeof (m as { id?: unknown }).id !== 'undefined'
}

// payload run ждёт только вычисление модуля — await на верхнем уровне
await main().catch((err) => {
  console.error('Ошибка seed:', err)
  process.exit(1)
})
