import { Block } from 'payload'

export const TestimonialsBlock: Block = {
  slug: 'testimonials',
  labels: { singular: 'Отзывы', plural: 'Отзывы' },
  fields: [
    { name: 'eyebrow', type: 'text', label: 'Надзаголовок', defaultValue: 'Отзывы клиентов' },
    { name: 'title', type: 'text', label: 'Заголовок', required: true },
    {
      name: 'items',
      type: 'array',
      label: 'Отзывы',
      minRows: 1,
      fields: [
        { name: 'quote', type: 'textarea', label: 'Текст отзыва', required: true },
        { name: 'author', type: 'text', label: 'Автор', required: true },
        { name: 'role', type: 'text', label: 'Контекст (напр. «Квартира 84 м²»)' },
      ],
    },
  ],
}
