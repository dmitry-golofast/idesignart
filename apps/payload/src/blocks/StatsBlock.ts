import { Block } from 'payload'

export const StatsBlock: Block = {
  slug: 'stats',
  labels: { singular: 'Цифры (статистика)', plural: 'Цифры' },
  fields: [
    {
      name: 'items',
      type: 'array',
      label: 'Показатели',
      minRows: 1,
      maxRows: 6,
      fields: [
        { name: 'value', type: 'text', label: 'Значение (напр. «120+»)', required: true },
        { name: 'label', type: 'text', label: 'Подпись (напр. «проектов»)', required: true },
      ],
    },
  ],
}
