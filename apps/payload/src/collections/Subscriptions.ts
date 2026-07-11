import { CollectionConfig } from 'payload'

export const Subscriptions: CollectionConfig = {
  slug: 'subscriptions',
  admin: {
    group: 'Лиды',
    useAsTitle: 'email',
    defaultColumns: ['email', 'source', 'consent', 'createdAt'],
    description:
      'Email-подписчики (лид-магниты, рассылка). Не путать с заявками — это контакты для прогрева.',
  },
  access: {
    read: ({ req: { user } }) => Boolean(user),
    create: () => true, // публичная подписка
    update: ({ req: { user } }) => Boolean(user),
    delete: ({ req: { user } }) => Boolean(user),
  },
  fields: [
    {
      name: 'email',
      type: 'email',
      required: true,
      unique: true,
    },
    {
      name: 'name',
      type: 'text',
    },
    {
      name: 'source',
      type: 'select',
      defaultValue: 'lead-magnet',
      options: [
        { label: 'Лид-магнит (гид)', value: 'lead-magnet' },
        { label: 'Newsletter', value: 'newsletter' },
        { label: 'Pop-up', value: 'popup' },
        { label: 'Footer', value: 'footer' },
        { label: 'Блог', value: 'blog' },
      ],
      admin: { position: 'sidebar' },
    },
    {
      name: 'leadMagnet',
      type: 'text',
      admin: {
        position: 'sidebar',
        description: 'Какой лид-магнит скачали (slug)',
      },
    },
    {
      name: 'status',
      type: 'select',
      defaultValue: 'subscribed',
      options: [
        { label: '✅ Подписан', value: 'subscribed' },
        { label: '⏸ Не подтверждён', value: 'pending' },
        { label: '❌ Отписан', value: 'unsubscribed' },
        { label: '🔁 В воронке', value: 'nurturing' },
      ],
      admin: { position: 'sidebar' },
    },
    {
      name: 'consent',
      type: 'checkbox',
      required: true,
      defaultValue: false,
    },
    {
      name: 'tags',
      type: 'array',
      admin: { position: 'sidebar' },
      fields: [{ name: 'tag', type: 'text' }],
    },
  ],
  timestamps: true,
}
