import { CollectionConfig } from 'payload'

export const Categories: CollectionConfig = {
  slug: 'categories',
  admin: {
    group: 'Контент',
    useAsTitle: 'title',
    description: 'Категории проектов и услуг: квартира, офис, визуализация и т.д. — основа для SEO-кластеров.',
  },
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
      admin: { position: 'sidebar' },
    },
    {
      name: 'description',
      type: 'textarea',
      admin: { description: 'Для SEO — выводится на странице категории.' },
    },
    {
      name: 'type',
      type: 'select',
      required: true,
      options: [
        { label: 'Тип проекта', value: 'project' },
        { label: 'Тип услуги', value: 'service' },
        { label: 'Стиль интерьера', value: 'style' },
      ],
      admin: { position: 'sidebar' },
    },
    {
      name: 'seoImage',
      type: 'upload',
      relationTo: 'media',
    },
  ],
  timestamps: true,
}
