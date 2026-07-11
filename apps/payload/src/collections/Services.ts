import { CollectionConfig } from 'payload'

export const Services: CollectionConfig = {
  slug: 'services',
  admin: {
    group: 'Услуги',
    useAsTitle: 'title',
    defaultColumns: ['title', 'slug', 'featured', 'order', '_status'],
    description:
      'Каждая услуга = отдельная посадочная страница под SEO/рекламу.',
  },
  versions: { drafts: true },
  access: {
    read: ({ req: { user } }) =>
      user ? true : { _status: { equals: 'published' } },
  },
  fields: [
    {
      name: 'title',
      type: 'text',
      required: true,
    },
    {
      name: 'slug',
      type: 'text',
      required: true,
      unique: true,
      admin: { position: 'sidebar', description: 'URL: /services/{slug}' },
    },
    {
      name: 'icon',
      type: 'upload',
      relationTo: 'media',
      admin: { description: 'Иконка/мини-рендер для карточки услуги.' },
    },
    {
      name: 'shortDescription',
      type: 'textarea',
      required: true,
      admin: { description: '1 предложение для карточки в сетке услуг.' },
    },
    {
      name: 'heroHeadline',
      type: 'text',
      required: true,
      admin: { description: 'H1 посадочной страницы услуги.' },
    },
    {
      name: 'heroSubheadline',
      type: 'textarea',
    },
    {
      name: 'heroImage',
      type: 'upload',
      relationTo: 'media',
    },
    {
      name: 'painPoints',
      type: 'array',
      label: 'Боли клиента',
      admin: { description: 'Что беспокоит клиента → снимаем возражения.' },
      fields: [{ name: 'point', type: 'text', required: true }],
    },
    {
      name: 'deliverables',
      type: 'array',
      label: 'Что входит',
      fields: [
        { name: 'item', type: 'text', required: true },
        { name: 'description', type: 'textarea' },
      ],
    },
    {
      name: 'body',
      type: 'richText',
      label: 'Подробное описание',
    },
    {
      name: 'pricing',
      type: 'group',
      label: 'Стоимость',
      fields: [
        {
          name: 'priceFrom',
          type: 'number',
          label: 'Цена от, ₽',
        },
        {
          name: 'unit',
          type: 'select',
          defaultValue: 'project',
          options: [
            { label: 'за м²', value: 'sqm' },
            { label: 'за проект', value: 'project' },
            { label: 'за час', value: 'hour' },
            { label: 'за рендер', value: 'render' },
          ],
        },
        {
          name: 'note',
          type: 'text',
          label: 'Примечание',
        },
      ],
    },
    {
      name: 'faqs',
      type: 'array',
      label: 'FAQ',
      admin: {
        description:
          'Вопросы → микроразметка FAQPage = расширенный сниппет в Google.',
      },
      fields: [
        { name: 'question', type: 'text', required: true },
        { name: 'answer', type: 'textarea', required: true },
      ],
    },
    {
      name: 'relatedProjects',
      type: 'relationship',
      relationTo: 'projects',
      hasMany: true,
      admin: { description: 'Кейсы по этой услуге.' },
    },
    {
      name: 'seo',
      type: 'group',
      admin: { group: 'SEO' },
      fields: [
        { name: 'title', type: 'text' },
        { name: 'description', type: 'textarea' },
        { name: 'keywords', type: 'text' },
        { name: 'ogImage', type: 'upload', relationTo: 'media' },
      ],
    },
    {
      name: 'order',
      type: 'number',
      defaultValue: 0,
      admin: { position: 'sidebar', description: 'Сортировка на странице услуг.' },
    },
    {
      name: 'featured',
      type: 'checkbox',
      defaultValue: false,
      admin: { position: 'sidebar' },
    },
  ],
  timestamps: true,
}
