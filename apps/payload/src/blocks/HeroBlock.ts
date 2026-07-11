import { Block } from 'payload'

export const HeroBlock: Block = {
  slug: 'hero',
  labels: { singular: 'Hero — обложка', plural: 'Hero — обложки' },
  fields: [
    { name: 'headline', type: 'text', label: 'Заголовок (H1)', required: true },
    { name: 'subheadline', type: 'textarea', label: 'Подзаголовок' },
    { name: 'image', type: 'upload', relationTo: 'media', label: 'Фоновое изображение', required: true },
    {
      name: 'ctaPrimary',
      type: 'group',
      label: 'Кнопка 1',
      fields: [
        { name: 'label', type: 'text' },
        { name: 'href', type: 'text' },
      ],
    },
    {
      name: 'ctaSecondary',
      type: 'group',
      label: 'Кнопка 2',
      fields: [
        { name: 'label', type: 'text' },
        { name: 'href', type: 'text' },
      ],
    },
  ],
}
