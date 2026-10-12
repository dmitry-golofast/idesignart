import { CollectionConfig } from 'payload'

export const Categories: CollectionConfig = {
  slug: 'categories',
  defaultSort: 'order',
  admin: {
    group: 'Контент',
    useAsTitle: 'title',
    description: 'Категории проектов и услуг: квартира, офис, визуализация и т.д. — основа для SEO-кластеров. Категории типа «Проект» становятся фильтрами в блоке «Наши работы».',
  },
  access: {
    // У категорий нет черновиков (поля _status не существует) — читают все.
    read: () => true,
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
      name: 'order',
      type: 'number',
      label: 'Порядок сортировки',
      admin: {
        position: 'sidebar',
        description: 'Меньше число — выше в фильтрах блока «Наши работы».',
      },
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
