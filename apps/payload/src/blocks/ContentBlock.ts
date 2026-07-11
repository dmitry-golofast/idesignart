import { Block } from 'payload'

export const ContentBlock: Block = {
  slug: 'content',
  labels: { singular: 'Текстовый блок', plural: 'Текстовые блоки' },
  fields: [
    { name: 'eyebrow', type: 'text', label: 'Надзаголовок' },
    { name: 'title', type: 'text', label: 'Заголовок' },
    { name: 'body', type: 'richText', label: 'Содержимое' },
    {
      name: 'layout',
      type: 'select',
      label: 'Раскладка',
      defaultValue: 'narrow',
      options: [
        { label: 'Узкая (статья)', value: 'narrow' },
        { label: 'Широкая', value: 'wide' },
      ],
    },
  ],
}
