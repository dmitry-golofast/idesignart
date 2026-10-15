import { Block } from 'payload'

export const ServicesBlock: Block = {
  slug: 'services-grid',
  labels: { singular: 'Сетка услуг', plural: 'Сетки услуг' },
  fields: [
    { name: 'title', type: 'text', label: 'Заголовок', required: true, defaultValue: 'Чем мы можем помочь' },
    {
      name: 'bgImage',
      type: 'upload',
      relationTo: 'media',
      label: 'Фоновое изображение блока',
      description:
        'Арт во всю секцию; рисунок прижимается к левому краю. Если пусто — берётся фото первой услуги.',
    },
  ],
}
