import type { GlobalConfig } from 'payload'
import { buildCtaGroup, validateHref } from '../fields/appearance'

/**
 * Header — отдельный global (меню, кнопка действия).
 *
 * Пункты меню (§04 спеки: header.navigation) и кнопка на структуре §06
 * (buildCtaGroup — та же фабрика, что у hero). Оформление (бывшая группа
 * appearance) выведено из CMS: дизайн-значения зашиты в CSS-токены
 * компонента AppHeader.vue и tokens.css — редактируются в коде, а не
 * в админке. Телефон в header не живёт — берётся из контактов Settings
 * (затем из переменных окружения).
 */
export const Header: GlobalConfig = {
  slug: 'header',
  label: 'Header',
  admin: {
    group: 'Настройки',
    description: 'Меню и кнопка действия в шапке сайта.',
  },
  access: {
    read: () => true, // публично — шапка рендерится на всех страницах
    update: ({ req: { user } }) => Boolean(user),
  },
  fields: [
    {
      type: 'array',
      name: 'navigation',
      label: 'Пункты меню',
      minRows: 0,
      maxRows: 6,
      labels: { singular: 'Пункт', plural: 'Пункты' },
      fields: [
        { type: 'text', name: 'label', label: 'Название', required: true, maxLength: 30 },
        {
          type: 'text',
          name: 'href',
          label: 'Ссылка',
          required: true,
          validate: validateHref,
          admin: { description: 'Относительный путь (/services), якорь (#pricing) или HTTPS-адрес' },
        },
        { type: 'checkbox', name: 'newTab', label: 'В новой вкладке', defaultValue: false },
      ],
    },
    buildCtaGroup('Кнопка действия', { label: 'Зарегистрироваться', href: '/register' }),
  ],
}
