import { GlobalConfig } from 'payload'

export const Settings: GlobalConfig = {
  slug: 'settings',
  admin: {
    group: 'Настройки',
    description: 'Глобальные настройки сайта: контакты, SEO по умолчанию, интеграции.',
  },
  access: {
    read: () => true, // публично — нужно для рендеринга футера/SEO на сайте
    update: ({ req: { user } }) => Boolean(user),
  },
  fields: [
    {
      name: 'brand',
      type: 'group',
      label: 'Бренд',
      fields: [
        { name: 'name', type: 'text', defaultValue: 'idesignart' },
        { name: 'tagline', type: 'text' },
        { name: 'logo', type: 'upload', relationTo: 'media' },
        { name: 'logoDark', type: 'upload', relationTo: 'media' },
      ],
    },
    {
      name: 'contacts',
      type: 'group',
      label: 'Контакты',
      fields: [
        { name: 'email', type: 'email' },
        { name: 'phone', type: 'text' },
        { name: 'whatsapp', type: 'text', admin: { description: 'С кодом страны, напр. 79991234567' } },
        { name: 'telegram', type: 'text', admin: { description: 'Username без @' } },
        { name: 'instagram', type: 'text' },
        { name: 'address', type: 'textarea' },
        {
          name: 'mapEmbed',
          type: 'text',
          admin: { description: 'URL embed Google/Яндекс Карт' },
        },
      ],
    },
    {
      name: 'socialProof',
      type: 'group',
      label: 'Социальное доказательство',
      fields: [
        { name: 'stats', type: 'array', label: 'Цифры', fields: [
          { name: 'value', type: 'text', required: true, label: 'Значение (напр. «120+»)' },
          { name: 'label', type: 'text', required: true, label: 'Подпись (напр. «проектов»)' },
        ] },
        { name: 'pressLogos', type: 'array', label: 'Логотипы изданий', fields: [
          { name: 'name', type: 'text' },
          { name: 'logo', type: 'upload', relationTo: 'media' },
          { name: 'url', type: 'text' },
        ] },
      ],
    },
    {
      name: 'seoDefaults',
      type: 'group',
      label: 'SEO по умолчанию',
      admin: { group: 'SEO' },
      fields: [
        { name: 'title', type: 'text' },
        { name: 'descriptionTemplate', type: 'text', admin: { description: 'Шаблон: %s — разделитель' } },
        { name: 'defaultOgImage', type: 'upload', relationTo: 'media' },
        { name: 'googleVerification', type: 'text' },
        { name: 'yandexVerification', type: 'text' },
      ],
    },
    {
      name: 'analytics',
      type: 'group',
      label: 'Аналитика',
      fields: [
        { name: 'gaId', type: 'text' },
        { name: 'yandexMetrikaId', type: 'text' },
        { name: 'plausibleDomain', type: 'text' },
      ],
    },
    {
      name: 'leadMagnet',
      type: 'group',
      label: 'Лид-магнит',
      fields: [
        { name: 'enabled', type: 'checkbox', defaultValue: true },
        { name: 'title', type: 'text' },
        { name: 'subtitle', type: 'textarea' },
        { name: 'guideFile', type: 'upload', relationTo: 'media' },
        { name: 'image', type: 'upload', relationTo: 'media' },
      ],
    },
  ],
}
