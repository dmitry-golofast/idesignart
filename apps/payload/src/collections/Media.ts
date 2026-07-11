import { CollectionConfig } from 'payload'

export const Media: CollectionConfig = {
  slug: 'media',
  admin: {
    group: 'Контент',
    description: 'Изображения, рендеры, видео. Alt-тексты обязательны для SEO и accessibility.',
  },
  access: {
    read: () => true, // публичный доступ — рендеры показываем всем
  },
  upload: {
    staticURL: '/media',
    staticDir: process.env.NODE_ENV === 'production' ? 'media' : '../../media',
    // Адаптивные размеры для @nuxt/image
    imageSizes: [
      { name: 'thumbnail', width: 400, height: 300, position: 'centre' },
      { name: 'card', width: 800, height: 600, position: 'centre' },
      { name: 'tablet', width: 1200, height: 900, position: 'centre' },
      { name: 'desktop', width: 1920, height: 1080, position: 'centre' },
      { name: 'featured', width: 2400, height: 1600, position: 'centre' },
    ],
    formatOptions: {
      format: 'webp',
      options: { quality: 82 },
    },
  },
  fields: [
    {
      name: 'alt',
      type: 'text',
      required: true,
      admin: {
        description: 'Описание изображения для SEO (Image Search) и скринридеров.',
      },
    },
    {
      name: 'caption',
      type: 'text',
    },
    {
      name: 'credit',
      type: 'text',
      admin: { description: 'Фотограф / визуализатор' },
    },
  ],
  timestamps: true,
}
