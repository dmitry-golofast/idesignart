import { GlobalConfig } from 'payload'

export const Settings: GlobalConfig = {
  slug: 'settings',
  admin: {
    group: 'Настройки',
    description:
      'Глобальные настройки сайта: контакты, SEO (дефолты — группа meta от плагина), верификация, интеграции.',
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
      // Дефолтные title/description/OG-картинка сайта живут в группе meta,
      // которую сюда добавляет seoPlugin (globals: ['settings']) — см. payload.config.
      name: 'seoDefaults',
      type: 'group',
      label: 'Верификация поисковиков',
      fields: [
        {
          name: 'googleVerification',
          type: 'text',
          admin: { description: 'Код Google Search Console (google-site-verification)' },
        },
        {
          name: 'yandexVerification',
          type: 'text',
          admin: { description: 'Код Яндекс Вебмастера (yandex-verification)' },
        },
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
  ],
}
