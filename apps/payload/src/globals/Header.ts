import type { GlobalConfig } from 'payload'
import { buildCtaGroup, hexColor, num, validateHref } from '../fields/appearance'

/**
 * Шапка сайта — отдельный global (меню, телефон, кнопка действия).
 *
 * Пункты меню (§04 спеки: header.navigation) и кнопка на структуре §06
 * (buildCtaGroup — та же фабрика, что у hero). Оформление — собственные поля
 * шапки, предзаполненные в стиле hero; управляется независимо от hero-блока.
 */
export const Header: GlobalConfig = {
  slug: 'header',
  label: 'Шапка сайта',
  admin: {
    group: 'Настройки',
    description:
      'Меню, телефон и кнопка действия в шапке. Оформление предзаполнено в стиле hero и управляется независимо.',
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
    {
      type: 'text',
      name: 'phone',
      label: 'Телефон',
      admin: {
        description: 'Пусто — берётся из контактов (Settings), затем из переменных окружения',
      },
    },
    buildCtaGroup('Кнопка действия', { label: 'Зарегистрироваться', href: '/register' }),
    {
      type: 'group',
      name: 'appearance',
      label: 'Оформление',
      admin: { description: 'Предзаполнено в стиле hero-блока; управляется независимо от него' },
      fields: [
        hexColor('backgroundColor', 'Фон', '#F8F7F3'),
        hexColor('textColor', 'Основной текст', '#080808'),
        hexColor('mutedTextColor', 'Вторичный текст (меню)', '#303030'),
        hexColor('accentColor', 'Акцент (кнопка)', '#D7EF28'),
        hexColor('accentTextColor', 'Текст на акценте', '#080808'),
        {
          type: 'select',
          name: 'fontFamily',
          label: 'Шрифт',
          defaultValue: 'inter',
          options: [
            { label: 'Inter', value: 'inter' },
            { label: 'Manrope', value: 'manrope' },
            { label: 'Системный', value: 'system' },
          ],
        },
        num('brandPx', 'Бренд, px', 20, 36, 30),
        num('navigationPx', 'Меню, px', 14, 20, 16),
        num('buttonTextPx', 'Текст кнопки, px', 14, 22, 18),
        num('buttonHeightPx', 'Высота кнопки, px', 44, 72, 56),
        num('buttonPaddingXPx', 'Отступ кнопки по X, px', 16, 40, 28),
        num('buttonRadiusPx', 'Скругление кнопки, px', 0, 12, 0),
        num('headerHeightPx', 'Высота шапки, px', 64, 112, 88),
      ],
    },
  ],
}
