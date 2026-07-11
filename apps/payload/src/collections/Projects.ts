import { CollectionConfig } from 'payload'

export const Projects: CollectionConfig = {
  slug: 'projects',
  admin: {
    group: 'Портфолио',
    useAsTitle: 'title',
    defaultColumns: [
      'title',
      'categories',
      'area',
      'status',
      'featured',
      '_status',
      'updatedAt',
    ],
    description:
      'Кейсы портфолио. Каждая страница кейса — посадочная для SEO long-tail трафика.',
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
      admin: { position: 'sidebar', description: 'URL: /portfolio/{slug}' },
    },
    {
      name: 'excerpt',
      type: 'textarea',
      required: true,
      admin: { description: 'Краткое описание для карточек и мета-тегов.' },
    },
    {
      name: 'coverImage',
      type: 'upload',
      relationTo: 'media',
      required: true,
      admin: { description: 'Обложка кейса (hero).' },
    },
    {
      name: 'gallery',
      type: 'array',
      label: 'Галерея',
      fields: [
        {
          name: 'image',
          type: 'upload',
          relationTo: 'media',
          required: true,
        },
        {
          name: 'caption',
          type: 'text',
        },
        {
          name: 'type',
          type: 'select',
          defaultValue: 'after',
          options: [
            { label: 'До', value: 'before' },
            { label: 'После', value: 'after' },
            { label: '3D-визуализация', value: 'render' },
            { label: 'План', value: 'plan' },
          ],
        },
      ],
    },
    {
      name: 'categories',
      type: 'relationship',
      relationTo: 'categories',
      hasMany: true,
      admin: {
        position: 'sidebar',
        description: 'Тип проекта, стиль — формирует кластеры и фильтры.',
      },
    },
    // ===== Метаданные проекта (SEO + социальное доказательство) =====
    {
      name: 'meta',
      type: 'group',
      label: 'Параметры проекта',
      admin: {
        description:
          'Эти данные → структурированный сниппет в выдаче и фильтры на сайте.',
      },
      fields: [
        { name: 'area', type: 'number', label: 'Площадь, м²' },
        {
          name: 'propertyType',
          type: 'select',
          options: [
            { label: 'Квартира', value: 'apartment' },
            { label: 'Дом', value: 'house' },
            { label: 'Офис', value: 'office' },
            { label: 'Ресторан / HoReCa', value: 'hospitality' },
            { label: ' Retail', value: 'retail' },
            { label: 'Другое', value: 'other' },
          ],
        },
        {
          name: 'style',
          type: 'select',
          options: [
            { label: 'Современный', value: 'modern' },
            { label: 'Минимализм', value: 'minimal' },
            { label: 'Скандинавский', value: 'scandi' },
            { label: 'Лофт', value: 'loft' },
            { label: 'Классика', value: 'classic' },
            { label: 'Неоклассика', value: 'neoclassic' },
            { label: 'Джапанди', value: 'japandi' },
            { label: 'Другое', value: 'other' },
          ],
        },
        { name: 'location', type: 'text', label: 'Локация / город' },
        { name: 'year', type: 'number' },
        { name: 'duration', type: 'text', label: 'Срок (напр. «3 месяца»)' },
        {
          name: 'budgetRange',
          type: 'select',
          label: 'Диапазон бюджета',
          options: [
            { label: 'до 500 тыс ₽', value: 'under-500k' },
            { label: '500 тыс – 1 млн ₽', value: '500k-1m' },
            { label: '1–3 млн ₽', value: '1m-3m' },
            { label: '3+ млн ₽', value: 'over-3m' },
            { label: 'Не указан', value: 'private' },
          ],
        },
      ],
    },
    // ===== Описание кейса (главный SEO-контент) =====
    {
      name: 'brief',
      type: 'richText',
      label: 'Задача клиента',
      admin: { description: 'Что нужно было решить. Это SEO-контент — пишите подробно.' },
    },
    {
      name: 'solution',
      type: 'richText',
      label: 'Решение',
      admin: { description: 'Что сделали и почему именно так.' },
    },
    {
      name: 'testimonial',
      type: 'group',
      label: 'Отзыв клиента',
      fields: [
        { name: 'quote', type: 'textarea' },
        { name: 'author', type: 'text' },
        { name: 'role', type: 'text' },
        { name: 'photo', type: 'upload', relationTo: 'media' },
      ],
    },
    // ===== SEO =====
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
      name: 'featured',
      type: 'checkbox',
      defaultValue: false,
      admin: {
        position: 'sidebar',
        description: 'Показывать на главной в «Избранных проектах».',
      },
    },
  ],
  timestamps: true,
}
