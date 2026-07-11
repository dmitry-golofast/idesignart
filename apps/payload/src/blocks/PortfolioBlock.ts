import { Block } from 'payload'

export const PortfolioBlock: Block = {
  slug: 'portfolio-grid',
  labels: { singular: 'Сетка проектов', plural: 'Сетки проектов' },
  fields: [
    { name: 'eyebrow', type: 'text', label: 'Надзаголовок', defaultValue: 'Избранные проекты' },
    { name: 'title', type: 'text', label: 'Заголовок', required: true },
    {
      name: 'limit',
      type: 'number',
      label: 'Кол-во проектов',
      defaultValue: 6,
      admin: { description: 'Сколько featured-проектов показать' },
    },
    { name: 'showAllButton', type: 'checkbox', label: 'Показать кнопку «Все проекты»', defaultValue: true },
  ],
}
