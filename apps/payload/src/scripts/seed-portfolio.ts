/**
 * Первичное наполнение портфолио для dev-среды: создаёт 6 проектов
 * с плейсхолдер-обложками (генерируются через sharp) и добавляет
 * на главную секцию portfolio-grid, если её ещё нет.
 *
 * Идемпотентен: проекты переиспользуются по slug, секция — по blockType.
 *
 * Запуск (нужен запущенный postgres):
 *   pnpm --filter payload exec payload run ./src/scripts/seed-portfolio.ts
 */
import { getPayload } from 'payload'
import sharp from 'sharp'
import payloadConfig from '../payload.config'

type AnyRecord = Record<string, unknown>

interface SeedProject {
  slug: string
  title: string
  excerpt: string
  propertyType: 'apartment' | 'house' | 'office' | 'hospitality' | 'retail'
  area: number
  featured: boolean
  /** Палитра плейсхолдера: тёплые интерьерные тона */
  palette: [string, string, string]
}

const PROJECTS: SeedProject[] = [
  {
    slug: 'kvartira-na-patriarshih',
    title: 'Квартира на Патриарших',
    excerpt: 'Современный минимализм с тёплыми акцентами в историческом центре Москвы',
    propertyType: 'apartment',
    area: 120,
    featured: true,
    palette: ['#e7ddce', '#cbbba4', '#8a7358'],
  },
  {
    slug: 'dom-v-zhukovke',
    title: 'Дом в Жуковке',
    excerpt: 'Пространство для большой семьи в окружении природы',
    propertyType: 'house',
    area: 350,
    featured: true,
    palette: ['#dde3d5', '#b8c2ab', '#6f7d63'],
  },
  {
    slug: 'shourum-mebeli',
    title: 'Шоурум мебели',
    excerpt: 'Функциональный и выразительный интерьер для бренда',
    propertyType: 'retail',
    area: 280,
    featured: true,
    palette: ['#e3e0da', '#c6c1b8', '#55524c'],
  },
  {
    slug: 'kofeynya-na-rozhdestvenke',
    title: 'Кофейня на Рождественке',
    excerpt: 'Уютное городское пространство с открытой кухней и бетонными акцентами',
    propertyType: 'hospitality',
    area: 140,
    featured: true,
    palette: ['#e9ded2', '#c9a98c', '#7a5c42'],
  },
  {
    slug: 'kvartira-v-hamovnikah',
    title: 'Квартира в Хамовниках',
    excerpt: 'Светлая классика с современным комфортом для семьи с детьми',
    propertyType: 'apartment',
    area: 86,
    featured: true,
    palette: ['#ece4d8', '#d4c3ae', '#96805f'],
  },
  {
    slug: 'ofis-it-kompanii',
    title: 'Офис IT-компании',
    excerpt: 'Гибкое рабочее пространство с переговорными и зонами тишины',
    propertyType: 'office',
    area: 450,
    featured: true,
    palette: ['#dfe2e4', '#b9bfc4', '#4d555b'],
  },
]

/** Демо-услуги для сетки (полные посадочные страницы не заполняем) */
const SERVICES = [
  { slug: 'apartment-design', title: 'Дизайн квартиры', shortDescription: 'Продуманный интерьер под ваш образ жизни — от планировки до подборки материалов.', order: 1 },
  { slug: 'office-design', title: 'Дизайн офиса', shortDescription: 'Рабочее пространство, которое усиливает бренд и продуктивность команды.', order: 2 },
  { slug: '3d-visualization', title: '3D-визуализация', shortDescription: 'Фотореалистичные рендеры: увидите результат до начала ремонта.', order: 3 },
  { slug: 'space-planning', title: 'Планировочные решения', shortDescription: 'Эргономика и зонирование без потери квадратных метров.', order: 4 },
  { slug: 'author-supervision', title: 'Авторский надзор', shortDescription: 'Контроль ремонта и соответствия проекту — вплоть до расстановки декора.', order: 5 },
]

/**
 * Целевой состав главной (воронка): hero (уже на странице) → услуги →
 * работы → процесс → цифры → отзывы → калькулятор → форма.
 */
const TARGET_SECTIONS: Record<string, unknown>[] = [
  {
    blockType: 'services-grid',
    eyebrow: 'Услуги',
    title: 'Чем мы можем помочь',
    description: 'Полный цикл: от планировки и визуализации до реализации под ключ.',
  },
  {
    blockType: 'portfolio-grid',
    eyebrow: 'Портфолио',
    title: 'Наши работы',
    limit: 6,
    showFilters: true,
    facts: [
      { icon: 'layers', value: '120+', label: 'реализованных проектов' },
      { icon: 'house', value: 'Квартиры, дома, коммерческие', label: 'все типы пространств' },
      { icon: 'leaf', value: 'Полный цикл', label: 'от концепции до реализации' },
    ],
  },
  {
    blockType: 'process-steps',
    eyebrow: 'Как мы работаем',
    title: 'Прозрачный процесс от идеи до переезда',
    steps: [
      { num: '01', title: 'Брифинг и концепция', description: 'Изучаем задачи, образ жизни, референсы. Формируем концепцию и планировочное решение.', duration: '1–2 недели' },
      { num: '02', title: '3D-визуализация', description: 'Создаём фотореалистичные рендеры каждого помещения. Вы видите результат до ремонта.', duration: '2–4 недели' },
      { num: '03', title: 'Рабочая документация', description: 'Чертежи, спецификации, смета. Все материалы и оборудование — с точным указанием.', duration: '2–3 недели' },
      { num: '04', title: 'Авторский надзор', description: 'Контролируем ход ремонта, корректируем отклонения. Сдаём готовый объект под ключ.', duration: 'до сдачи' },
    ],
  },
  {
    blockType: 'stats',
    eyebrow: 'Студия в цифрах',
    items: [
      { value: '120+', label: 'реализованных проектов' },
      { value: '8 лет', label: 'опыта в дизайне интерьеров' },
      { value: '98%', label: 'клиентов рекомендуют нас' },
      { value: '×2', label: 'быстрее продаётся объект с визуализацией' },
    ],
  },
  {
    blockType: 'testimonials',
    eyebrow: 'Отзывы',
    title: 'Что говорят клиенты',
    items: [
      { quote: 'Визуализация настолько точная, что квартира совпала с рендерами один в один. Продали объект на этапе ремонта.', author: 'Анна и Игорь', role: 'Квартира 84 м²' },
      { quote: 'Смета не выросла ни на рубль — всё зафиксировали в документации. Надзор снял с нас все вопросы со строителями.', author: 'Дмитрий К.', role: 'Дом 210 м²' },
      { quote: 'Шоурум после редизайна стал главным «продающим» элементом: трафик и средний чек выросли заметно.', author: 'Мария В.', role: 'Шоурум мебели, 280 м²' },
    ],
  },
  {
    blockType: 'pricing-calculator',
    eyebrow: 'Прозрачные цены',
    title: 'Узнайте стоимость вашего проекта',
  },
  {
    blockType: 'contact-form',
    eyebrow: 'Связаться',
    title: 'Расскажите о вашем проекте',
  },
]

async function ensureService(payload: Awaited<ReturnType<typeof getPayload>>, s: (typeof SERVICES)[number]) {
  const existing = await payload.find({
    collection: 'services',
    where: { slug: { equals: s.slug } },
    limit: 1,
    depth: 0,
  })
  if (existing.docs[0]) {
    // Черновики публикуем, порядок синхронизируем (сид-контент должен быть виден на сайте)
    if (existing.docs[0]._status !== 'published' || existing.docs[0].order !== s.order) {
      await payload.update({
        collection: 'services',
        id: existing.docs[0].id as number,
        data: { _status: 'published', order: s.order },
      })
      payload.logger.info(`услуга обновлена: ${s.slug}`)
    }
    return existing.docs[0].id as number
  }
  const created = await payload.create({
    collection: 'services',
    draft: false,
    data: {
      title: s.title,
      slug: s.slug,
      shortDescription: s.shortDescription,
      heroHeadline: s.title,
      order: s.order,
      featured: true,
      _status: 'published',
    },
  })
  payload.logger.info(`услуга создана: ${s.slug} (id=${created.id})`)
  return created.id as number
}

async function placeholderJpeg(index: number, palette: [string, string, string]): Promise<Buffer> {
  const [bg, mid, dark] = palette
  const svg = `
    <svg width="1600" height="1000" xmlns="http://www.w3.org/2000/svg">
      <rect width="1600" height="1000" fill="${bg}"/>
      <rect x="0" y="620" width="1600" height="380" fill="${mid}"/>
      <rect x="180" y="180" width="560" height="440" rx="8" fill="${dark}" opacity="0.85"/>
      <rect x="860" y="180" width="560" height="440" rx="8" fill="${dark}" opacity="0.45"/>
      <rect x="180" y="700" width="1240" height="140" rx="8" fill="${dark}" opacity="0.3"/>
      <circle cx="1380" cy="120" r="60" fill="${dark}" opacity="0.25"/>
      <text x="90" y="880" font-family="Arial, sans-serif" font-size="120" font-weight="700" fill="${dark}" opacity="0.6">0${index + 1}</text>
    </svg>`
  return sharp(Buffer.from(svg)).jpeg({ quality: 82 }).toBuffer()
}

async function ensureMedia(payload: Awaited<ReturnType<typeof getPayload>>, project: SeedProject, index: number) {
  const existing = await payload.find({
    collection: 'media',
    where: { title: { equals: `Плейсхолдер — ${project.title}` } },
    limit: 1,
    depth: 0,
  })
  if (existing.docs[0]) return existing.docs[0].id as number

  const buffer = await placeholderJpeg(index, project.palette)
  const media = await payload.create({
    collection: 'media',
    data: {
      title: `Плейсхолдер — ${project.title}`,
      alt: `${project.title} — ${project.excerpt}`,
      credit: 'Плейсхолдер для dev-среды',
    },
    file: {
      data: buffer,
      mimetype: 'image/jpeg',
      name: `${project.slug}-cover.jpg`,
      size: buffer.length,
    },
  })
  payload.logger.info(`media создано: id=${media.id} (${project.slug})`)
  return media.id as number
}

/** Категории типа «Проект» — из них строятся фильтры блока «Наши работы» */
const CATEGORIES = [
  { slug: 'kvartiry', title: 'Квартиры', order: 1 },
  { slug: 'chastnye-doma', title: 'Частные дома', order: 2 },
  { slug: 'kommerskie', title: 'Коммерческие', order: 3 },
  { slug: 'horeca', title: 'HoReCa', order: 4 },
] as const

/** propertyType проекта → slug категории */
const CATEGORY_BY_TYPE: Record<SeedProject['propertyType'], string> = {
  apartment: 'kvartiry',
  house: 'chastnye-doma',
  office: 'kommerskie',
  retail: 'kommerskie',
  hospitality: 'horeca',
}

async function run() {
  const payload = await getPayload({ config: payloadConfig })

  // Категории фильтров
  const categoryIds: Record<string, number> = {}
  for (const c of CATEGORIES) {
    const existing = await payload.find({
      collection: 'categories',
      where: { slug: { equals: c.slug } },
      limit: 1,
      depth: 0,
    })
    if (existing.docs[0]) {
      categoryIds[c.slug] = existing.docs[0].id as number
      continue
    }
    const created = await payload.create({
      collection: 'categories',
      data: { title: c.title, slug: c.slug, type: 'project', order: c.order },
    })
    categoryIds[c.slug] = created.id as number
    payload.logger.info(`категория создана: ${c.slug} (id=${created.id})`)
  }

  // Проекты
  const projectIds: number[] = []
  for (const [index, p] of PROJECTS.entries()) {
    const existing = await payload.find({
      collection: 'projects',
      where: { slug: { equals: p.slug } },
      limit: 1,
      depth: 0,
    })
    const categoryId = categoryIds[CATEGORY_BY_TYPE[p.propertyType]]
    if (existing.docs[0]) {
      // Привязываем категорию, если проект ещё без неё (идемпотентность)
      if (!existing.docs[0].categories?.length) {
        await payload.update({
          collection: 'projects',
          id: existing.docs[0].id as number,
          data: { categories: [categoryId] },
        })
        payload.logger.info(`категория привязана к ${p.slug}`)
      }
      projectIds.push(existing.docs[0].id as number)
      continue
    }
    const coverId = await ensureMedia(payload, p, index)
    const created = await payload.create({
      collection: 'projects',
      draft: false,
      data: {
        title: p.title,
        slug: p.slug,
        excerpt: p.excerpt,
        coverImage: coverId,
        categories: [categoryId],
        meta: { area: p.area, propertyType: p.propertyType, style: 'minimal' },
        featured: p.featured,
        _status: 'published',
      },
    })
    projectIds.push(created.id as number)
    payload.logger.info(`проект создан: ${p.slug} (id=${created.id})`)
  }

  // Услуги для сетки
  for (const s of SERVICES) {
    await ensureService(payload, s)
  }

  // Секции главной: hero сохраняем как есть, остальные — целевой набор по воронке
  const pages = await payload.find({
    collection: 'pages',
    where: { slug: { equals: 'home' } },
    limit: 1,
    depth: 0,
  })
  const page = pages.docs[0]

  if (!page) {
    const created = await payload.create({
      collection: 'pages',
      draft: false,
      data: {
        title: 'Главная',
        slug: 'home',
        sections: TARGET_SECTIONS,
        _status: 'published',
      },
    })
    payload.logger.info(`✅ страница home создана с полным набором секций (id=${created.id})`)
    return
  }

  const existingSections = (page.sections ?? []) as AnyRecord[]
  const hero = existingSections.filter(s => s.blockType === 'hero')

  // Идемпотентно: обновляем content портфолио из TARGET_SECTIONS,
  // чужие (не входящие в целевой набор) блоки пользователя сохраняем в конце.
  const targetTypes = new Set(TARGET_SECTIONS.map(s => s.blockType))
  const preserved = existingSections.filter(s => !targetTypes.has(s.blockType as string) && s.blockType !== 'hero')

  await payload.update({
    collection: 'pages',
    id: page.id,
    data: { sections: [...hero, ...TARGET_SECTIONS, ...preserved] },
  })
  payload.logger.info(`✅ секции главной собраны (hero + ${TARGET_SECTIONS.length} блоков), проектов готово: ${projectIds.length}`)
}

await run().catch((err) => {
  console.error('Ошибка seed-portfolio:', err)
  process.exit(1)
})
