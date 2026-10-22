import { CollectionConfig } from 'payload'
import { HeroBlock } from '../blocks/HeroBlock'
import { ServicesBlock } from '../blocks/ServicesBlock'
import { PortfolioBlock } from '../blocks/PortfolioBlock'
import { ProcessBlock } from '../blocks/ProcessBlock'
import { TestimonialsBlock } from '../blocks/TestimonialsBlock'
import { ContentBlock } from '../blocks/ContentBlock'
import { CtaBlock } from '../blocks/CtaBlock'
import { ContactBlock } from '../blocks/ContactBlock'
import { AboutBlock } from '../blocks/AboutBlock'

// SEO-поля (meta.title/description/image/noindex) добавляет плагин
// @payloadcms/plugin-seo — см. payload.config.ts

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
        description: 'Перетаскивайте блоки, чтобы собрать страницу. Порядок = порядок на сайте.',
      },
      blocks: [
        HeroBlock,
        AboutBlock,
        ServicesBlock,
        PortfolioBlock,
        ProcessBlock,
        TestimonialsBlock,
        ContentBlock,
        CtaBlock,
        ContactBlock,
      ],
    },
  ],
  timestamps: true,
}
