import { Block } from 'payload'

export const ServicesBlock: Block = {
  slug: 'services-grid',
  labels: { singular: 'Сетка услуг', plural: 'Сетки услуг' },
  fields: [
    { name: 'eyebrow', type: 'text', label: 'Надзаголовок', defaultValue: 'Что мы делаем' },
    { name: 'title', type: 'text', label: 'Заголовок', required: true, defaultValue: 'Услуги' },
    { name: 'description', type: 'textarea', label: 'Описание секции' },
  ],
}
