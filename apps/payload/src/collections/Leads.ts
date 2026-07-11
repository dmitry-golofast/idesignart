import { CollectionConfig } from 'payload'

export const Leads: CollectionConfig = {
  slug: 'leads',
  admin: {
    group: 'Лиды',
    useAsTitle: 'name',
    defaultColumns: [
      'name',
      'contact',
      'service',
      'source',
      'status',
      'createdAt',
    ],
    description:
      'Заявки с сайта. Сортируйте по status и source для воронки продаж.',
  },
  access: {
    // Лиды видят только аутентифицированные пользователи (приватно)
    read: ({ req: { user } }) => Boolean(user),
    create: () => true, // публичная отправка форм
    update: ({ req: { user } }) => Boolean(user),
    delete: ({ req: { user } }) => Boolean(user),
  },
  fields: [
    {
      name: 'name',
      type: 'text',
      required: true,
    },
    {
      name: 'contact',
      type: 'group',
      required: true,
      fields: [
        { name: 'email', type: 'email' },
        { name: 'phone', type: 'text' },
      ],
      admin: {
        description: 'Минимум одно поле контакта (email или телефон).',
      },
    },
    {
      name: 'service',
      type: 'relationship',
      relationTo: 'services',
      admin: {
        description: 'Интересующая услуга — определяет квалификацию лида.',
      },
    },
    {
      name: 'projectDetails',
      type: 'group',
      fields: [
        { name: 'propertyType', type: 'text', label: 'Тип объекта' },
        { name: 'area', type: 'number', label: 'Площадь, м²' },
        { name: 'budget', type: 'text', label: 'Бюджет' },
        { name: 'timeline', type: 'text', label: 'Сроки' },
      ],
    },
    {
      name: 'message',
      type: 'textarea',
      required: true,
    },
    {
      name: 'source',
      type: 'select',
      defaultValue: 'website',
      options: [
        { label: 'Сайт (форма)', value: 'website' },
        { label: 'Калькулятор', value: 'calculator' },
        { label: 'Лид-магнит', value: 'lead-magnet' },
        { label: 'WhatsApp', value: 'whatsapp' },
        { label: 'Telegram', value: 'telegram' },
        { label: 'Реклама (Google)', value: 'ads-google' },
        { label: 'Реклама (Яндекс)', value: 'ads-yandex' },
        { label: 'Соцсети', value: 'social' },
        { label: 'Сарафанное радио', value: 'referral' },
        { label: 'Прочее', value: 'other' },
      ],
      admin: { position: 'sidebar' },
    },
    {
      name: 'status',
      type: 'select',
      defaultValue: 'new',
      options: [
        { label: '🆕 Новая', value: 'new' },
        { label: '📞 В работе', value: 'in-progress' },
        { label: '✅ Квалифицирован', value: 'qualified' },
        { label: '🤝 Встреча назначена', value: 'meeting' },
        { label: '💸 Клиент', value: 'won' },
        { label: '❌ Отказ', value: 'lost' },
        { label: '⏸ Отложен', value: 'nurture' },
      ],
      admin: { position: 'sidebar' },
    },
    {
      name: 'assignedTo',
      type: 'relationship',
      relationTo: 'users',
      admin: { position: 'sidebar' },
    },
    {
      name: 'notes',
      type: 'textarea',
      admin: { position: 'sidebar' },
    },
    // Согласие на обработку (GDPR / 152-ФЗ)
    {
      name: 'consent',
      type: 'checkbox',
      required: true,
      defaultValue: false,
      admin: {
        description: 'Согласие на обработку персональных данных.',
      },
    },
  ],
  timestamps: true,
}
