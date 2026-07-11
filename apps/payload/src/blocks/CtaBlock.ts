import { Block } from 'payload'

export const CtaBlock: Block = {
  slug: 'cta-banner',
  labels: { singular: 'CTA-баннер', plural: 'CTA-баннеры' },
  fields: [
    { name: 'title', type: 'text', label: 'Заголовок', required: true },
    { name: 'description', type: 'textarea', label: 'Подзаголовок' },
    {
      name: 'primaryCta',
      type: 'group',
      label: 'Кнопка',
      fields: [
        { name: 'label', type: 'text', defaultValue: 'Оставить заявку' },
        { name: 'href', type: 'text', defaultValue: '/contacts' },
      ],
    },
    {
      name: 'variant',
      type: 'select',
      label: 'Вид',
      defaultValue: 'dark',
      options: [
        { label: 'Тёмная (графит)', value: 'dark' },
        { label: 'Светлая (акцент)', value: 'accent' },
      ],
    },
  ],
}
