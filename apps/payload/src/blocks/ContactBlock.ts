import { Block } from 'payload'

export const ContactBlock: Block = {
  slug: 'contact-form',
  labels: { singular: 'Форма заявки', plural: 'Формы заявки' },
  fields: [
    { name: 'eyebrow', type: 'text', label: 'Надзаголовок', defaultValue: 'Связаться' },
    { name: 'title', type: 'text', label: 'Заголовок', required: true, defaultValue: 'Расскажите о проекте' },
    { name: 'description', type: 'textarea', label: 'Описание' },
  ],
}
