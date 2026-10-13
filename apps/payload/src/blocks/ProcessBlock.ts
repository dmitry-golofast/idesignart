import { Block } from 'payload'

export const ProcessBlock: Block = {
  slug: 'process-steps',
  labels: { singular: 'Процесс (шаги)', plural: 'Процесс' },
  fields: [
    { name: 'eyebrow', type: 'text', label: 'Надзаголовок', defaultValue: 'Процесс' },
    { name: 'title', type: 'text', label: 'Заголовок', required: true, defaultValue: 'Как мы работаем' },
    {
      name: 'description',
      type: 'text',
      label: 'Подзаголовок',
      defaultValue: 'Четыре листа — от первой идеи до готового интерьера',
    },
    {
      name: 'steps',
      type: 'array',
      label: 'Шаги (листы)',
      minRows: 2,
      maxRows: 6,
      defaultValue: [
        { num: '01', title: 'Брифинг и концепция', description: 'Изучаем задачи и референсы. Формируем концепцию и планировочное решение.', duration: '1–2 недели', sketch: 'plan' },
      ],
      fields: [
        { name: 'num', type: 'text', label: 'Номер (01, 02, ...)', required: true },
        { name: 'title', type: 'text', label: 'Заголовок', required: true },
        { name: 'description', type: 'textarea', label: 'Описание (раскрывается по клику)', required: true },
        { name: 'duration', type: 'text', label: 'Срок (напр. «2 недели»)' },
        {
          name: 'sketch',
          type: 'select',
          label: 'Чертёж на листе (рисуется на canvas)',
          defaultValue: 'plan',
          options: [
            { label: 'План помещения с размерами', value: 'plan' },
            { label: 'Изометрия комнаты', value: 'iso' },
            { label: 'Развертка стены', value: 'elevation' },
            { label: 'Перспектива комнаты', value: 'perspective' },
          ],
        },
      ],
    },
  ],
}
