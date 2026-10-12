import { Block } from 'payload'

export const PortfolioBlock: Block = {
  slug: 'portfolio-grid',
  labels: { singular: 'Сетка проектов', plural: 'Сетки проектов' },
  fields: [
    { name: 'eyebrow', type: 'text', label: 'Надзаголовок', defaultValue: 'Портфолио' },
    { name: 'title', type: 'text', label: 'Заголовок', required: true },
    {
      name: 'projects',
      type: 'relationship',
      relationTo: 'projects',
      hasMany: true,
      label: 'Проекты (ручной выбор)',
      admin: {
        description:
          'Выбранные проекты показываются на сайте в этом порядке. Если пусто — автоматически берутся избранные (галочка featured у проекта) в количестве «Кол-во проектов».',
      },
    },
    {
      name: 'limit',
      type: 'number',
      label: 'Кол-во проектов',
      defaultValue: 6,
      admin: {
        description: 'Работает только в авто-режиме: сколько избранных проектов показать',
      },
    },
    {
      name: 'showFilters',
      type: 'checkbox',
      label: 'Показать фильтры',
      defaultValue: true,
      admin: {
        description:
          'Чипы-фильтры строятся из категорий типа «Проект» (Контент → Категории, порядок задаётся полем «Порядок сортировки»)',
      },
    },
    {
      name: 'facts',
      type: 'array',
      label: 'Инфо-карточки справа от заголовка',
      maxRows: 3,
      defaultValue: [
        { icon: 'layers', value: '120+', label: 'реализованных проектов' },
        { icon: 'house', value: 'Квартиры, дома, коммерческие', label: 'все типы пространств' },
        { icon: 'leaf', value: 'Полный цикл', label: 'от концепции до реализации' },
      ],
      fields: [
        {
          name: 'icon',
          type: 'select',
          label: 'Иконка',
          required: true,
          options: [
            { label: 'Слои (проекты)', value: 'layers' },
            { label: 'Дом (типы объектов)', value: 'house' },
            { label: 'Лист (полный цикл)', value: 'leaf' },
            { label: 'Компас', value: 'compass' },
          ],
          defaultValue: 'layers',
        },
        { name: 'value', type: 'text', label: 'Акцент (напр. «120+»)', required: true },
        { name: 'label', type: 'text', label: 'Подпись', required: true },
      ],
    },
  ],
}
