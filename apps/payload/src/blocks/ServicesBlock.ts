import { Block } from 'payload'

export const ServicesBlock: Block = {
  slug: 'services-grid',
  labels: { singular: 'Сетка услуг', plural: 'Сетки услуг' },
  fields: [
    { name: 'title', type: 'text', label: 'Заголовок', required: true, defaultValue: 'Чем мы можем помочь' },
    {
      name: 'description',
      type: 'textarea',
      label: 'Описание (справа от заголовка)',
      defaultValue: 'Полный цикл: от планировки и визуализации до реализации под ключ.',
    },
  ],
}
