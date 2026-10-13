import type { Block } from 'payload'
import { buildCtaGroup, num } from '../fields/appearance'

/**
 * Hero — главный экран сайта (референс VirtualStaging, спека hero-payload-cms-spec.md).
 *
 * Структура повторяет спеку: группы hero (§05) с общей структурой кнопки (§06)
 * и bottomLine (§07). SEO-поля живут в коллекции Pages (§11),
 * шапка — отдельный global «header».
 *
 * Оформление (бывшая группа §08) выведено из CMS: дизайн-значения зашиты
 * в CSS-токены компонента HeroSection.vue — редактируются в коде, а не
 * в админке.
 * Ссылки — только относительные пути /…, якоря #… и абсолютные HTTPS (§06).
 * Общие хелперы полей и фабрика кнопки — в src/fields/appearance.ts
 * (используются также global «header»).
 */

export const HeroBlock: Block = {
  slug: 'hero',
  labels: { singular: 'Hero — главный экран', plural: 'Hero — главные экраны' },
  fields: [
    // =========================================================
    // §05 — контент главного блока
    // =========================================================
    {
      type: 'group',
      name: 'hero',
      label: 'Главный блок',
      fields: [
        {
          type: 'text',
          name: 'eyebrow',
          label: 'Надзаголовок',
          maxLength: 70,
          defaultValue: 'ЦИФРОВОЙ ДИЗАЙН ИНТЕРЬЕРОВ',
          admin: { description: 'Пустое значение скрывает строку' },
        },
        {
          type: 'array',
          name: 'titleLines',
          label: 'Строки заголовка H1',
          minRows: 1,
          maxRows: 3,
          required: true,
          labels: { singular: 'Строка', plural: 'Строки' },
          fields: [
            {
              type: 'text',
              name: 'text',
              label: 'Текст строки',
              required: true,
              maxLength: 30,
            },
          ],
        },
        {
          type: 'textarea',
          name: 'description',
          label: 'Описание',
          maxLength: 220,
          defaultValue:
            'Превращаем пустые комнаты в выразительные интерьеры для продажи недвижимости.',
        },
        buildCtaGroup('Кнопка'),
        {
          type: 'upload',
          name: 'image',
          label: 'Главное изображение',
          relationTo: 'media',
          required: true,
          admin: { description: 'Панорамный интерьер от 2400 px по ширине, без надписей' },
        },
        {
          type: 'upload',
          name: 'mobileImage',
          label: 'Мобильное изображение',
          relationTo: 'media',
          admin: { description: 'Необязательное; без него используется главное с мобильным кадрированием' },
        },
        {
          type: 'text',
          name: 'imageAlt',
          label: 'Alt изображения',
          required: true,
          defaultValue:
            'Светлая гостиная с панорамными окнами, кремовым диваном и терракотовым креслом',
        },
        {
          type: 'text',
          name: 'mobileImageAlt',
          label: 'Alt мобильного изображения',
          admin: { description: 'Необязательное; по умолчанию берётся alt главного изображения' },
        },
        {
          type: 'text',
          name: 'imageCaption',
          label: 'Подпись на фотографии',
          maxLength: 80,
          defaultValue: '01 / Тёплый минимализм',
        },
        {
          type: 'checkbox',
          name: 'showImageCaption',
          label: 'Показывать подпись',
          defaultValue: true,
        },
        num('imagePositionX', 'Кадрирование X, %', 0, 100, 50, 'Горизонталь object-position'),
        num('imagePositionY', 'Кадрирование Y, %', 0, 100, 50, 'Вертикаль object-position'),
        num('mobileImagePositionX', 'Мобильное кадрирование X, %', 0, 100, 50),
        num('mobileImagePositionY', 'Мобильное кадрирование Y, %', 0, 100, 50),
        num(
          'captionOverlayOpacity',
          'Затемнение под подписью',
          0,
          0.6,
          0.15,
          'Прозрачность градиента в нижней части фото (0–0.6)',
        ),
      ],
    },

    // =========================================================
    // §07 — нижняя строка
    // =========================================================
    {
      type: 'group',
      name: 'bottomLine',
      label: 'Нижняя строка',
      fields: [
        { type: 'checkbox', name: 'enabled', label: 'Показывать строку', defaultValue: true },
        {
          type: 'text',
          name: 'leftText',
          label: 'Текст слева',
          maxLength: 80,
          defaultValue: 'Ваш объект. Новый взгляд.',
        },
        {
          type: 'text',
          name: 'rightText',
          label: 'Текст справа',
          maxLength: 80,
          defaultValue: 'Виртуальный хоумстейджинг',
        },
        {
          type: 'checkbox',
          name: 'showDivider',
          label: 'Разделитель между подписями',
          defaultValue: true,
          admin: { description: 'Линия декоративная, скрыта от скринридеров и на мобильном' },
        },
      ],
    },
  ],
}
