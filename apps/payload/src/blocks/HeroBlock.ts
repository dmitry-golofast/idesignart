import type { Block, Field } from 'payload'
import { buildCtaGroup, hexColor, num } from '../fields/appearance'

/**
 * Hero — главный экран сайта (референс VirtualStaging, спека hero-payload-cms-spec.md).
 *
 * Структура повторяет спеку: группы hero (§05) с общей структурой кнопки (§06),
 * bottomLine (§07) и appearance (§08). SEO-поля живут в коллекции Pages (§11),
 * шапка — отдельный global «header».
 *
 * Все цвета — HEX #RRGGBB, числовые поля с min/max из §08, ссылки — только
 * относительные пути /…, якоря #… и абсолютные HTTPS (§06).
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

    // =========================================================
    // §08 — настройки дизайна → CSS-переменные компонента
    // =========================================================
    {
      type: 'group',
      name: 'appearance',
      label: 'Оформление',
      admin: { description: 'Цвета, типографика и размеры экрана. Применяются через CSS-переменные.' },
      fields: [
        hexColor('backgroundColor', 'Фон', '#F8F7F3'),
        hexColor('textColor', 'Основной текст', '#080808'),
        hexColor('mutedTextColor', 'Вторичный текст', '#303030'),
        hexColor('accentColor', 'Акцент (кнопки)', '#D7EF28'),
        hexColor('accentTextColor', 'Текст на акценте', '#080808'),
        hexColor('dividerColor', 'Разделитель', '#B8B8B5'),
        hexColor('captionColor', 'Подпись на фото', '#FFFFFF'),
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
        {
          type: 'select',
          name: 'titleWeight',
          label: 'Насыщенность заголовка',
          defaultValue: '800',
          options: [
            { label: '700', value: '700' },
            { label: '800', value: '800' },
            { label: '900', value: '900' },
          ],
        },
        num('titleDesktopPx', 'Заголовок, desktop px', 72, 144, 116),
        num('titleMobilePx', 'Заголовок, mobile px', 32, 64, 48),
        num('titleLineHeight', 'Интерлиньяж заголовка', 0.95, 1.2, 0.98),
        num('titleLetterSpacingEm', 'Трекинг заголовка, em', -0.06, 0, -0.045),
        num('bodyDesktopPx', 'Текст, desktop px', 16, 28, 22),
        num('bodyMobilePx', 'Текст, mobile px', 16, 22, 18),
        num('bodyLineHeight', 'Интерлиньяж текста', 1.2, 1.8, 1.4),
        num('brandPx', 'Бренд, px', 20, 36, 30, 'Размер шрифта бренда в шапке'),
        num('navigationPx', 'Навигация, px', 14, 20, 16, 'Размер шрифта пунктов меню'),
        num('eyebrowPx', 'Надзаголовок, px', 11, 16, 12),
        num('eyebrowLetterSpacingEm', 'Трекинг надзаголовка, em', 0, 0.4, 0.3),
        num('captionPx', 'Подпись на фото, px', 12, 18, 14),
        num('bottomLinePx', 'Нижняя строка, px', 12, 18, 14),
        num('buttonTextPx', 'Текст кнопки, px', 14, 22, 18),
        num('buttonHeightPx', 'Высота кнопки, px', 44, 72, 56),
        num('buttonPaddingXPx', 'Отступ кнопки по X, px', 16, 40, 28),
        num('buttonRadiusPx', 'Скругление кнопки, px', 0, 12, 0),
        num('contentMaxWidthPx', 'Макс. ширина контента, px', 1100, 1920, 1600),
        num('desktopGutterPx', 'Боковой отступ, desktop px', 24, 80, 48),
        num('mobileGutterPx', 'Боковой отступ, mobile px', 16, 32, 20),
        num('headerHeightPx', 'Высота шапки, px', 64, 112, 88, 'Учитывается в расчёте высоты экрана'),
        num('heroTopPaddingPx', 'Отступ сверху, px', 24, 80, 40),
        num('heroBottomPaddingPx', 'Отступ до фото, px', 24, 80, 36),
        num('heroColumnGapPx', 'Колонки: промежуток, px', 24, 80, 48),
        num(
          'titleColumnPercent',
          'Колонка заголовка, %',
          60,
          72,
          68,
          'Доля ширины строки заголовка, остальное — описание и кнопка',
        ),
        num('descriptionButtonGapPx', 'Описание → кнопка, px', 16, 40, 28),
        num('mobileStackGapPx', 'Вертикальный ритм, px', 16, 40, 24),
        {
          type: 'select',
          name: 'imageWidth',
          label: 'Ширина изображения',
          defaultValue: 'full-bleed',
          options: [
            { label: 'На всю ширину', value: 'full-bleed' },
            { label: 'В контейнере', value: 'contained' },
          ],
        },
        {
          type: 'select',
          name: 'imageDesktopRatio',
          label: 'Пропорция, desktop',
          defaultValue: '3:1',
          options: [
            { label: '3:1', value: '3:1' },
            { label: '16:9', value: '16:9' },
            { label: '21:9', value: '21:9' },
          ],
        },
        {
          type: 'select',
          name: 'imageMobileRatio',
          label: 'Пропорция, mobile',
          defaultValue: '4:3',
          options: [
            { label: '4:3', value: '4:3' },
            { label: '1:1', value: '1:1' },
            { label: '3:4', value: '3:4' },
          ],
        },
        num('imageRadiusPx', 'Скругление фото, px', 0, 24, 0),
        num(
          'captionInsetPx',
          'Отступ подписи от края, px',
          16,
          48,
          32,
          'На мобильном ограничивается боковым отступом',
        ),
        num('bottomLinePaddingYPx', 'Нижняя строка: отступ по Y, px', 16, 40, 24),
        num('dividerThicknessPx', 'Толщина разделителя, px', 1, 2, 1),
      ],
    },
  ],
}
