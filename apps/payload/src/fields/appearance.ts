import type { Field } from 'payload'

/**
 * Общие поля стиля и кнопки, переиспользуются hero-блоком (§06, §08 спеки)
 * и global «Шапка сайта» (header).
 *
 * Все цвета — HEX #RRGGBB, числовые поля с min/max, ссылки — только
 * относительные пути /…, якоря #… и абсолютные HTTPS.
 * Обязательность полей выключенной CTA проверяется серверно (§12),
 * в админке они дополнительно скрываются через admin.condition.
 */

const HEX_COLOR_RE = /^#[0-9a-fA-F]{6}$/

/** Валидация ссылки: /…, #…, https://… — остальное отклоняем (§06) */
export const validateHref = (value: unknown): true | string => {
  if (value === null || value === undefined || value === '') return true
  const href = String(value)
  if (href.startsWith('/') && !href.startsWith('//')) return true
  if (href.startsWith('#')) return true
  if (/^https:\/\/\S+$/i.test(href)) return true
  return 'Допустимы относительные пути (/…), якоря (#…) и абсолютные HTTPS-адреса'
}

/** Обязательное поле включённой кнопки: серверная проверка, а не только admin.condition (§12) */
const validateRequiredWhenEnabled = (value: unknown, options: any): true | string => {
  const sibling = (options?.siblingData ?? {}) as Record<string, unknown>
  if (sibling.enabled === false) return true
  if (value === null || value === undefined || String(value).trim() === '') {
    return 'Обязательно, пока кнопка включена'
  }
  return true
}

/** Валидация HEX-цвета формата #RRGGBB (§08) */
export const validateHexColor = (value: unknown): true | string => {
  if (value === null || value === undefined || value === '') return true
  return HEX_COLOR_RE.test(String(value)) || 'Введите цвет в формате #RRGGBB'
}

/** Цветовое поле с проверкой HEX (§08) */
export const hexColor = (name: string, label: string, defaultValue: string): Field => ({
  type: 'text',
  name,
  label,
  defaultValue,
  maxLength: 7,
  validate: validateHexColor,
})

/** Числовое поле стиля с min/max из таблицы §08 */
export const num = (
  name: string,
  label: string,
  min: number,
  max: number,
  defaultValue: number,
  description?: string,
): Field => ({
  type: 'number',
  name,
  label,
  min,
  max,
  defaultValue,
  required: true,
  admin: { description },
})

/**
 * Группа кнопки (§06). Одинаковая структура для header.cta и hero.cta.
 * defaults — стартовые подпись/ссылка конкретного места использования.
 */
export const buildCtaGroup = (
  label: string,
  defaults: { label?: string; href?: string } = {},
): Field => ({
  type: 'group',
  name: 'cta',
  label,
  fields: [
    { type: 'checkbox', name: 'enabled', label: 'Показывать кнопку', defaultValue: true },
    {
      type: 'text',
      name: 'label',
      label: 'Подпись',
      maxLength: 32,
      ...(defaults.label ? { defaultValue: defaults.label } : {}),
      validate: validateRequiredWhenEnabled,
      admin: {
        condition: (_data, siblingData) => (siblingData as Record<string, unknown>)?.enabled !== false,
      },
    },
    {
      type: 'text',
      name: 'href',
      label: 'Ссылка',
      ...(defaults.href ? { defaultValue: defaults.href } : {}),
      validate: (value: unknown, options: any) =>
        validateHref(value) === true ? validateRequiredWhenEnabled(value, options) : validateHref(value),
      admin: {
        condition: (_data, siblingData) => (siblingData as Record<string, unknown>)?.enabled !== false,
        description: 'Относительный путь (/start), якорь (#pricing) или HTTPS-адрес',
      },
    },
    { type: 'checkbox', name: 'newTab', label: 'Открывать в новой вкладке', defaultValue: false },
    {
      type: 'select',
      name: 'icon',
      label: 'Иконка',
      defaultValue: 'arrow-up-right',
      options: [
        { label: 'Стрелка ↗', value: 'arrow-up-right' },
        { label: 'Стрелка →', value: 'arrow-right' },
        { label: 'Без иконки', value: 'none' },
      ],
    },
    {
      type: 'select',
      name: 'variant',
      label: 'Вариант',
      defaultValue: 'accent',
      options: [
        { label: 'Акцентный', value: 'accent' },
        { label: 'Тёмный', value: 'dark' },
        { label: 'Контурный', value: 'outline' },
      ],
    },
  ],
})
