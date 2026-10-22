import type { Block } from 'payload'

/**
 * AboutHero — шапка страницы «О студии»: текст слева, фото справа,
 * под фото — цитата основателя. Блок закреплён за страницей slug=about
 * (сид seed-about.ts); на других страницах обычно не используется.
 * Оформление — в токенах компонента AboutHero.vue, здесь только контент.
 */
export const AboutBlock: Block = {
  slug: 'about-hero',
  labels: { singular: 'О студии — шапка', plural: 'О студии — шапки' },
  fields: [
    {
      type: 'text',
      name: 'title',
      label: 'Заголовок',
      required: true,
      maxLength: 120,
      defaultValue: 'Создаём пространства, в которых хочется жить и работать',
    },
    {
      type: 'textarea',
      name: 'description',
      label: 'Описание',
      maxLength: 500,
      defaultValue:
        'idesignart — студия дизайна интерьера и 3D-визуализации. Мы проектируем квартиры, дома и общественные пространства, объединяя эстетику и функциональность.',
    },
    {
      type: 'upload',
      name: 'photo',
      relationTo: 'media',
      label: 'Фото справа',
      admin: { description: 'Вертикальный или квадратный кадр от 1000 px; без фото — декоративная панель' },
    },
    {
      type: 'text',
      name: 'photoAlt',
      label: 'Alt фото',
      admin: { description: 'Описание для скринридеров и поисковых роботов' },
    },
    {
      type: 'textarea',
      name: 'quote',
      label: 'Цитата основателя',
      maxLength: 400,
      admin: { description: 'Показывается под фото; пустое значение скрывает цитату' },
    },
    {
      type: 'text',
      name: 'quoteAuthor',
      label: 'Имя основателя',
      maxLength: 80,
    },
    {
      type: 'text',
      name: 'quoteRole',
      label: 'Роль основателя',
      maxLength: 80,
      admin: { description: 'Например: основатель и главный дизайнер' },
    },
  ],
}
