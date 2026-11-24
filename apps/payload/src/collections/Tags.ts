import { CollectionConfig } from 'payload'

export const Tags: CollectionConfig = {
  slug: 'tags',
  admin: {
    group: 'Блог',
    useAsTitle: 'title',
    defaultColumns: ['title', 'slug'],
    description:
      'Теги статей — свободные ключевые слова, отдельная сущность от категорий (типов проектов).',
  },
  access: {
    // Публичный контент: читают все (популируются в постах на фронте)
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
  ],
  timestamps: true,
}
