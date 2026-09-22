/**
 * Наполнение global «header» (Шапка сайта) стартовыми данными:
 * пункты меню, кнопка «Зарегистрироваться» (/register), оформление в стиле hero.
 * Плюс создание страницы-заглушки /register в Pages, если её нет.
 *
 * Идемпотентен: непустые поля не перезаписывает — правки из админки не затирает.
 *
 * Запуск: pnpm --filter payload exec payload run ./src/scripts/seed-header.ts
 */
import { getPayload } from 'payload'
import payloadConfig from '../payload.config'

/** Стартовые пункты меню — бывший захардкоженный список AppHeader */
const DEFAULT_NAV = [
  { label: 'Услуги', href: '/services' },
  { label: 'Портфолио', href: '/portfolio' },
  { label: 'Процесс', href: '/process' },
  { label: 'О студии', href: '/about' },
  { label: 'Блог', href: '/blog' },
  { label: 'Контакты', href: '/contacts' },
]

/** Оформление шапки — значения из оформления hero-блока (§08 спеки) */
const appearance = {
  backgroundColor: '#F8F7F3',
  textColor: '#080808',
  mutedTextColor: '#303030',
  accentColor: '#D7EF28',
  accentTextColor: '#080808',
  fontFamily: 'inter',
  brandPx: 30,
  navigationPx: 16,
  buttonTextPx: 18,
  buttonHeightPx: 56,
  buttonPaddingXPx: 28,
  buttonRadiusPx: 0,
  headerHeightPx: 88,
}

async function main() {
  console.log('[seed-header] старт')
  const payload = await getPayload({ config: payloadConfig })

  // 1. Global header
  const header = await payload.findGlobal({ slug: 'header', depth: 0 })

  await payload.updateGlobal({
    slug: 'header',
    data: {
      // Пункты меню заполняем только если список пуст
      navigation:
        header.navigation && header.navigation.length > 0
          ? header.navigation
          : DEFAULT_NAV,
      phone: header.phone ?? null,
      cta: {
        enabled: header.cta?.enabled ?? true,
        label: header.cta?.label || 'Зарегистрироваться',
        href: header.cta?.href || '/register',
        newTab: header.cta?.newTab ?? false,
        icon: header.cta?.icon || 'arrow-up-right',
        variant: header.cta?.variant || 'accent',
      },
      appearance,
    },
  })
  payload.logger.info('Global header заполнен')

  // 2. Страница-заглушка /register
  const existing = await payload.find({
    collection: 'pages',
    where: { slug: { equals: 'register' } },
    limit: 1,
    depth: 0,
  })

  if (existing.docs[0]) {
    payload.logger.info(`Страница /register уже существует (id=${existing.docs[0].id})`)
  } else {
    const page = await payload.create({
      collection: 'pages',
      draft: false,
      data: {
        title: 'Регистрация',
        slug: 'register',
        sections: [
          {
            blockType: 'content',
            eyebrow: 'ЛИЧНЫЙ КАБИНЕТ',
            title: 'Регистрация',
            body: [
              {
                type: 'p',
                children: [
                  {
                    text: 'Форма регистрации появится здесь. Пока оставьте заявку через контакты — вернёмся с доступами.',
                  },
                ],
              },
            ],
            layout: 'narrow',
          },
        ],
        seo: {
          title: 'Регистрация — idesignart',
          description: 'Создайте аккаунт idesignart, чтобы управлять проектами виртуального хоумстейджинга.',
          noindex: true,
        },
        _status: 'published',
      },
    })
    payload.logger.info(`Страница /register создана (id=${page.id})`)
  }

  payload.logger.info('✅ Шапка и страница регистрации готовы')
}

// payload run ждёт только вычисление модуля — await на верхнем уровне
await main().catch((err) => {
  console.error('Ошибка seed:', err)
  process.exit(1)
})
