/**
 * Перенос контента в hero-блок главной страницы (первичное наполнение
 * или перенос между средами, например dev → prod).
 *
 * Режимы:
 *  1. Экспорт (на исходной среде):
 *       HERO_SEED_EXPORT=1 payload run ./src/scripts/seed-hero.ts
 *     Пишет JSON текущего hero-блока в HERO_SEED_OUTPUT (по умолчанию
 *     ./hero-content.export.json).
 *
 *  2. Применение (на целевой среде) — по умолчанию:
 *       HERO_SEED_DATA=/path/hero-content.json payload run ./src/scripts/seed-hero.ts
 *     Переносит контент из файла экспорта. Без HERO_SEED_DATA — стартовый
 *     контент по спеке hero-payload-cms-spec.md.
 *
 * Медиа (в порядке приоритета): переиспользуется по служебному title →
 * загружается из файла HERO_SEED_IMAGE → скачивается из URL в данных →
 * остаётся текущее фото блока.
 *
 * Прод (контейнер idesignart-admin; WORKDIR /app/apps/admin — чтобы media
 * попали в volume):
 *   docker cp hero-content.export.json idesignart-admin:/tmp/
 *   docker exec -e HERO_SEED_DATA=/tmp/hero-content.export.json \
 *     -w /app/apps/admin idesignart-admin \
 *     npx payload run /app/apps/payload/src/scripts/seed-hero.ts
 */
import { getPayload } from 'payload'
import fs from 'node:fs'
import path from 'node:path'
import payloadConfig from '../payload.config'

const EXPORT_FLAG = process.env.HERO_SEED_EXPORT === '1'
const DATA_FILE = process.env.HERO_SEED_DATA || ''
const OUTPUT_FILE = process.env.HERO_SEED_OUTPUT || 'hero-content.export.json'
const MEDIA_TITLE = 'Hero — тёплый минимализм'

/** Стартовая кнопка hero — структура §06 спеки */
const DEFAULT_CTA = {
  enabled: true,
  label: 'Создать интерьер',
  href: '/contacts',
  newTab: false,
  icon: 'arrow-up-right',
  variant: 'accent',
}

// Оформление hero (бывшая группа §08) выведено из CMS — живёт в CSS-токенах
// HeroSection.vue, сид его не трогает.

function payloadBase(): string {
  return process.env.PAYLOAD_PUBLIC_SERVER_URL || 'http://localhost:3000'
}

/** ---------- экспорт ---------- */
async function runExport() {
  const payload = await getPayload({ config: payloadConfig })
  const base = payloadBase()

  const pages = await payload.find({
    collection: 'pages',
    where: { slug: { equals: 'home' } },
    limit: 1,
    depth: 1,
  })
  const page = pages.docs[0]
  if (!page) throw new Error('Страница slug=home не найдена')

  const section = (page.sections ?? []).find((s: { blockType?: string }) => s.blockType === 'hero') as
    | { hero?: Record<string, unknown>; bottomLine?: Record<string, unknown> }
    | undefined
  if (!section?.hero) throw new Error('На странице home нет hero-блока')

  const image = section.hero.image as { url?: string; alt?: string; title?: string; credit?: string } | number | null
  const media =
    image && typeof image === 'object'
      ? {
          title: image.title || MEDIA_TITLE,
          alt: image.alt || '',
          credit: image.credit || 'Unsplash',
          // depth=1 отдаёт url уже абсолютным — префиксуем только относительные
          url: image.url ? (image.url.startsWith('http') ? image.url : `${base}${image.url}`) : null,
        }
      : null

  const out = {
    exportedAt: new Date().toISOString(),
    source: base,
    media,
    hero: {
      eyebrow: section.hero.eyebrow ?? null,
      titleLines: section.hero.titleLines ?? null,
      description: section.hero.description ?? null,
      cta: section.hero.cta ?? null,
      imageAlt: section.hero.imageAlt ?? null,
      imageCaption: section.hero.imageCaption ?? null,
      showImageCaption: section.hero.showImageCaption ?? null,
      imagePositionX: section.hero.imagePositionX ?? null,
      imagePositionY: section.hero.imagePositionY ?? null,
      mobileImagePositionX: section.hero.mobileImagePositionX ?? null,
      mobileImagePositionY: section.hero.mobileImagePositionY ?? null,
      captionOverlayOpacity: section.hero.captionOverlayOpacity ?? null,
    },
    bottomLine: section.bottomLine ?? null,
  }

  const file = path.resolve(process.cwd(), OUTPUT_FILE)
  fs.writeFileSync(file, JSON.stringify(out, null, 2))
  payload.logger.info(`✅ Контент hero выгружен в ${file}`)
}

/** ---------- применение ---------- */
type AnyRecord = Record<string, unknown>

const isMedia = (m: unknown): m is { id: number | string } =>
  Boolean(m) && typeof m === 'object' && typeof (m as { id?: unknown }).id !== 'undefined'

async function resolveMedia(payload: Awaited<ReturnType<typeof getPayload>>, data: AnyRecord) {
  // 1. Уже загружено (идемпотентность по служебному title)
  const existing = await payload.find({
    collection: 'media',
    where: { title: { equals: MEDIA_TITLE } },
    limit: 1,
    depth: 0,
  })
  if (existing.docs[0]) {
    payload.logger.info(`Media переиспользовано: id=${existing.docs[0].id}`)
    return existing.docs[0].id as number
  }

  // 2. Локальный файл (docker cp + HERO_SEED_IMAGE)
  if (process.env.HERO_SEED_IMAGE) {
    const filePath = path.resolve(process.cwd(), process.env.HERO_SEED_IMAGE)
    const media = await payload.create({
      collection: 'media',
      data: { alt: data.alt, title: MEDIA_TITLE, credit: data.credit },
      filePath,
    })
    payload.logger.info(`Media загружено из файла: id=${media.id}`)
    return media.id as number
  }

  // 3. URL из экспорта / явный HERO_SEED_IMAGE_URL
  const media = data as { media?: { url?: string; alt?: string; title?: string; credit?: string } }
  const url = process.env.HERO_SEED_IMAGE_URL || media.media?.url
  if (url) {
    payload.logger.info(`Скачиваю медиа: ${url}`)
    const res = await fetch(url)
    if (!res.ok) throw new Error(`Не удалось скачать медиа (${res.status}): ${url}`)
    const buffer = Buffer.from(await res.arrayBuffer())
    const created = await payload.create({
      collection: 'media',
      data: { alt: media.media?.alt ?? data.alt, title: MEDIA_TITLE, credit: media.media?.credit },
      file: {
        data: buffer,
        mimetype: res.headers.get('content-type') || 'image/jpeg',
        name: url.split('/').pop() || 'hero-panorama.jpg',
        size: buffer.length,
      },
    })
    payload.logger.info(`Media загружено по URL: id=${created.id}`)
    return created.id as number
  }

  return null
}

async function runApply() {
  console.log(`[seed-hero] режим применения, данные: ${DATA_FILE || 'встроенные дефолты спеки'}`)
  const payload = await getPayload({ config: payloadConfig })

  let data: AnyRecord = {}
  if (DATA_FILE) {
    const file = path.resolve(process.cwd(), DATA_FILE)
    data = JSON.parse(fs.readFileSync(file, 'utf8')) as AnyRecord
  }

  // Медиа
  const incoming = (data.hero ?? {}) as AnyRecord
  const mediaId = await resolveMedia(payload, {
    alt: str(incoming.imageAlt, 'Светлая гостиная с панорамным окном'),
    ...data,
  })

  // Страница home
  const pages = await payload.find({
    collection: 'pages',
    where: { slug: { equals: 'home' } },
    limit: 1,
    depth: 0,
  })
  const page = pages.docs[0]

  const section = (page?.sections ?? []).find((s: { blockType?: string }) => s.blockType === 'hero') as
    | { hero?: AnyRecord }
    | undefined
  const currentHero = section?.hero ?? {}

  // Перенос: значения из данных перекрывают текущие; отсутствующие — дефолты спеки.
  // Пустые строки из данных игнорируем (не затираем контент пустотой).
  const incomingHero = (data.hero ?? {}) as AnyRecord
  const nonEmpty = (v: unknown) => (typeof v === 'string' ? v.length > 0 : v !== null && v !== undefined)
  const hero = {
    eyebrow: nonEmpty(incomingHero.eyebrow) ? incomingHero.eyebrow : str(currentHero.eyebrow, 'ЦИФРОВОЙ ДИЗАЙН ИНТЕРЬЕРОВ'),
    titleLines:
      Array.isArray(incomingHero.titleLines) && incomingHero.titleLines.length > 0
        ? // id из среды-источника не переносим
          (incomingHero.titleLines as AnyRecord[]).map(({ text }) => ({ text }))
        : Array.isArray(currentHero.titleLines) && currentHero.titleLines.length > 0
          ? currentHero.titleLines
          : [{ text: 'Пространство.' }, { text: 'С характером.' }],
    description: nonEmpty(incomingHero.description)
      ? incomingHero.description
      : str(currentHero.description as string, 'Превращаем пустые комнаты в выразительные интерьеры для продажи недвижимости.'),
    cta: {
      ...DEFAULT_CTA,
      ...((currentHero.cta ?? {}) as AnyRecord),
      ...(typeof incomingHero.cta === 'object' && incomingHero.cta !== null ? (incomingHero.cta as AnyRecord) : {}),
    },
    image: mediaId ?? (isMedia(currentHero.image) ? currentHero.image.id : currentHero.image) ?? undefined,
    imageAlt: nonEmpty(incomingHero.imageAlt)
      ? incomingHero.imageAlt
      : str(currentHero.imageAlt as string, 'Светлая гостиная с панорамным окном, кремовым диваном и тёплым деревянным полом'),
    imageCaption: nonEmpty(incomingHero.imageCaption) ? incomingHero.imageCaption : str(currentHero.imageCaption as string, '01 / Тёплый минимализм'),
    showImageCaption: incomingHero.showImageCaption ?? currentHero.showImageCaption ?? true,
    imagePositionX: incomingHero.imagePositionX ?? currentHero.imagePositionX ?? 50,
    imagePositionY: incomingHero.imagePositionY ?? currentHero.imagePositionY ?? 60,
    mobileImagePositionX: incomingHero.mobileImagePositionX ?? currentHero.mobileImagePositionX ?? 50,
    mobileImagePositionY: incomingHero.mobileImagePositionY ?? currentHero.mobileImagePositionY ?? 60,
    // 0.35 вместо дефолтных 0.15: белая подпись на светлом дереве нечитаема при 0.15
    captionOverlayOpacity: incomingHero.captionOverlayOpacity ?? currentHero.captionOverlayOpacity ?? 0.35,
  }

  const bottomLine = {
    enabled: true,
    leftText: 'Ваш объект. Новый взгляд.',
    rightText: 'Виртуальный хоумстейджинг',
    showDivider: true,
    ...((data.bottomLine as AnyRecord | undefined) ?? {}),
  }

  const otherSections = (page?.sections ?? []).filter((s: { blockType: string }) => s.blockType !== 'hero')

  const heroSection = {
    blockType: 'hero',
    hero,
    bottomLine,
  }

  // Страницы нет (свежая база) — создаём home сразу с hero-блоком
  if (!page) {
    const created = await payload.create({
      collection: 'pages',
      draft: false,
      data: {
        title: 'Главная',
        slug: 'home',
        sections: [heroSection],
        seo: {
          title: 'idesignart — студия дизайна интерьера и 3D-визуализации',
          description:
            'Создаем выразительные интерьеры на фотографиях недвижимости. Покажите потенциал пространства.',
        },
        _status: 'published',
      },
    })
    payload.logger.info(`✅ Страница home создана с hero-блоком (id=${created.id})`)
    return
  }

  await payload.update({
    collection: 'pages',
    id: page.id,
    data: {
      sections: [heroSection, ...otherSections],
    },
  })

  payload.logger.info('✅ Контент перенесён в hero-блок главной страницы')
}

function str(v: unknown, d: string): string {
  return typeof v === 'string' && v.length > 0 ? v : d
}

if (EXPORT_FLAG) {
  await runExport().catch((err) => {
    console.error('Ошибка экспорта:', err)
    process.exit(1)
  })
} else {
  await runApply().catch((err) => {
    console.error('Ошибка seed:', err)
    process.exit(1)
  })
}
