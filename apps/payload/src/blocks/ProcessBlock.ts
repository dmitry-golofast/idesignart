import { Block } from 'payload'

export const ProcessBlock: Block = {
  slug: 'process-steps',
  labels: { singular: 'Процесс (шаги)', plural: 'Процесс' },
  fields: [
    { name: 'eyebrow', type: 'text', label: 'Надзаголовок', defaultValue: 'Как мы работаем' },
    { name: 'title', type: 'text', label: 'Заголовок', required: true },
    {
      name: 'steps',
      type: 'array',
      label: 'Шаги',
      minRows: 2,
      maxRows: 6,
      defaultValue: [
        { num: '01', title: 'Брифинг и концепция', description: 'Изучаем задачи и референсы. Формируем концепцию и планировочное решение.', duration: '1–2 недели' },
      ],
      fields: [
        { name: 'num', type: 'text', label: 'Номер (01, 02, ...)', required: true },
        { name: 'title', type: 'text', label: 'Заголовок', required: true },
        { name: 'description', type: 'textarea', label: 'Описание', required: true },
        { name: 'duration', type: 'text', label: 'Срок (напр. «2 недели»)' },
      ],
    },
  ],
}
