import { Block } from 'payload'

export const PricingBlock: Block = {
  slug: 'pricing-calculator',
  labels: { singular: 'Калькулятор стоимости', plural: 'Калькуляторы' },
  fields: [
    { name: 'eyebrow', type: 'text', label: 'Надзаголовок', defaultValue: 'Прозрачные цены' },
    { name: 'title', type: 'text', label: 'Заголовок', required: true, defaultValue: 'Узнайте стоимость' },
  ],
}
