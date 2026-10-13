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
        {
          name: 'icon',
          type: 'select',
          label: 'Иконка',
          options: [
            { label: 'Слои (проекты)', value: 'layers' },
            { label: 'Дом (объекты)', value: 'house' },
            { label: 'Лист (полный цикл)', value: 'leaf' },
            { label: 'Компас', value: 'compass' },
            { label: 'Сердце (рекомендации)', value: 'heart' },
            { label: 'График (рост, выгода)', value: 'trending-up' },
          ],
          defaultValue: 'layers',
        },
        { name: 'value', type: 'text', label: 'Значение (напр. «120+»)', required: true },
        { name: 'label', type: 'text', label: 'Подпись (напр. «проектов»)', required: true },
        {
          name: 'description',
          type: 'text',
          label: 'Пояснение (мелкий текст под чертой)',
        },
        {
          name: 'image',
          type: 'upload',
          relationTo: 'media',
          label: 'Фоновая картинка',
          admin: {
            description:
              'Скетч или фото интерьера — показывается полупрозрачно в верхней части карточки, текст остаётся на белой подложке',
          },
        },
      ],
    },
  ],
}
