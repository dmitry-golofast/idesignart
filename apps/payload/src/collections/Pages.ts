import { CollectionConfig, Field } from 'payload'
import { HeroBlock } from '../blocks/HeroBlock'
import { StatsBlock } from '../blocks/StatsBlock'
import { ServicesBlock } from '../blocks/ServicesBlock'
import { PortfolioBlock } from '../blocks/PortfolioBlock'
import { ProcessBlock } from '../blocks/ProcessBlock'
import { PricingBlock } from '../blocks/PricingBlock'
import { TestimonialsBlock } from '../blocks/TestimonialsBlock'
import { ContentBlock } from '../blocks/ContentBlock'
import { CtaBlock } from '../blocks/CtaBlock'
import { ContactBlock } from '../blocks/ContactBlock'

const seoFields: Field[] = [
  {
    name: 'seo',
    type: 'group',
    admin: {
      group: 'SEO',
      description: 'Метаданные страницы для поисковых систем и социальных сетей.',
    },
    fields: [
      { name: 'title', type: 'text', label: 'Meta Title (≤60 симв.)' },
      {
        name: 'description',
        type: 'textarea',
        label: 'Meta Description (≤160 симв.)',
      },
      {
        name: 'keywords',
        type: 'text',
        label: 'Ключевые слова (для справки, в выдаче не используется)',
      },
      { name: 'ogImage', type: 'upload', relationTo: 'media' },
      {
        name: 'noindex',
        type: 'checkbox',
        defaultValue: false,
        label: 'Скрыть из индексации',
      },
    ],
  },
]

export const Pages: CollectionConfig = {
  slug: 'pages',
  admin: {
    group: 'Контент',
    useAsTitle: 'title',
    description: 'Динамические страницы сайта (главная, о нас, контакты, услуги).',
  },
  versions: {
    drafts: true,
  },
  access: {
    read: ({ req: { user } }) =>
      user ? true : { _status: { equals: 'published' } },
    create: ({ req: { user } }) => Boolean(user),
    update: ({ req: { user } }) => Boolean(user),
    delete: ({ req: { user } }) => Boolean(user),
  },
  fields: [
    {
      name: 'title',
      type: 'text',
      required: true,
    },
    {
      name: 'slug',
      type: 'text',
      required: true,
      unique: true,
      admin: { position: 'sidebar', description: 'URL: /{slug}' },
      defaultValue: 'home',
    },
    {
      name: 'sections',
      type: 'blocks',
      label: 'Блоки страницы',
      admin: {
        group: 'Контент страницы',
        description: 'Перетаскивайте блоки, чтобы собрать страницу. Порядок = порядок на сайте.',
      },
      blocks: [
        HeroBlock,
        StatsBlock,
        ServicesBlock,
        PortfolioBlock,
        ProcessBlock,
        PricingBlock,
        TestimonialsBlock,
        ContentBlock,
        CtaBlock,
        ContactBlock,
      ],
    },
    ...seoFields,
  ],
  timestamps: true,
}
