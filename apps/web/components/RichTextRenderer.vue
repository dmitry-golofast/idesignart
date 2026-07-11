<script setup lang="ts">
/**
 * RichTextRenderer — рекурсивный рендерер Payload Lexical JSON (SerializedEditorState).
 *
 * Зачем свой, а не @payloadcms/richtext-lexical/react:
 *   официальный рендерер — React-only. Для Nuxt/Vue делаем свой —
 *   это даёт полный контроль над стилями под премиум-дизайн и
 *   не тянет React в bundle.
 *
 * Поддерживаемые узлы:
 *   - paragraph, heading (h1–h4), text, link
 *   - list (bullet/number), listitem, quote, horizontalrule
 *   - upload (image)
 *
 * Компонент ссылается сам на себя (рекурсия) для вложенных детей.
 */

interface LexicalNode {
  type: string
  tag?: string | string[]
  format?: number
  listType?: 'bullet' | 'number'
  url?: string
  rel?: string
  target?: string
  text?: string
  children?: LexicalNode[]
  value?: { url?: string; alt?: string; filename?: string; width?: number; height?: number }
  direction?: string | null
}

type LexicalContent =
  | LexicalNode
  | LexicalNode[]
  | { root?: { children?: LexicalNode[] } }
  | null
  | undefined

const props = defineProps<{
  content: LexicalContent
}>()

const config = useRuntimeConfig()
const payloadBase = config.public.payloadApiUrl as string

// Lexical TextFormat bitmask flags
const IS_BOLD = 1
const IS_ITALIC = 2
const IS_STRIKETHROUGH = 4
const IS_UNDERLINE = 8

/** Нормализуем вход в массив узлов верхнего уровня */
function toNodes(input: LexicalContent): LexicalNode[] {
  if (!input) return []
  if (Array.isArray(input)) return input
  if ('root' in input && input.root?.children) return input.root.children
  return [input as LexicalNode]
}

const nodes = computed(() => toNodes(props.content))

/** Превращаем URL из Payload в абсолютный */
function imgUrl(url?: string): string {
  if (!url) return ''
  return url.startsWith('http') ? url : `${payloadBase}${url}`
}

/** Классы для инлайн-форматирования текста по bitmask */
function inlineClasses(format = 0): string[] {
  const cls: string[] = []
  if (format & IS_BOLD) cls.push('font-semibold')
  if (format & IS_ITALIC) cls.push('italic')
  if (format & IS_STRIKETHROUGH) cls.push('line-through')
  if (format & IS_UNDERLINE) cls.push('underline')
  return cls
}

/** Заголовок: tag может быть строкой или массивом */
function headingTag(tag?: string | string[]): string {
  if (Array.isArray(tag)) return tag[0] || 'h2'
  return tag || 'h2'
}

/** inline-форматирование текста -> <span> с классами, либо plain текст */
function renderText(text: string, format = 0): string {
  return text
}
</script>

<template>
  <div class="prose-content space-y-5 text-[var(--text-body)] leading-[var(--text--body--line-height)] text-[var(--color-ink-muted)]">
    <template v-for="(node, i) in nodes" :key="i">
      <!-- Параграф -->
      <p v-if="node.type === 'paragraph'" class="text-inherit">
        <template v-for="(child, j) in node.children" :key="j">
          <a
            v-if="child.type === 'link'"
            :href="child.url"
            :rel="child.rel || 'noopener noreferrer'"
            :target="child.target || '_blank'"
            class="text-[var(--color-accent)] underline underline-offset-2 hover:text-[var(--color-accent-deep)]"
          >
            {{ child.children?.map((c) => c.text || '').join('') }}
          </a>
          <span v-else-if="child.text" :class="inlineClasses(child.format)">{{ child.text }}</span>
        </template>
      </p>

      <!-- Заголовок -->
      <component
        :is="headingTag(node.tag)"
        v-else-if="node.type === 'heading'"
        class="font-display text-[var(--color-ink)]"
        :class="{
          'text-[var(--text-h2)] mt-10': headingTag(node.tag) === 'h2',
          'text-[var(--text-h3)] mt-8': headingTag(node.tag) === 'h3',
          'text-[var(--text-h4)] mt-6': headingTag(node.tag) === 'h4',
        }"
      >
        <template v-for="(child, j) in node.children" :key="j">
          <span :class="inlineClasses(child.format)">{{ child.text }}</span>
        </template>
      </component>

      <!-- Список -->
      <ul
        v-else-if="node.type === 'list' && node.listType === 'bullet'"
        class="list-disc space-y-2 pl-6 marker:text-[var(--color-accent)]"
      >
        <li v-for="(item, j) in node.children" :key="j">
          <template v-for="(c, k) in item.children" :key="k">
            <p v-if="c.type === 'text'" :class="inlineClasses(c.format)">{{ c.text }}</p>
            <RichTextRenderer v-else :content="[c]" class="!space-y-0" />
          </template>
        </li>
      </ul>
      <ol
        v-else-if="node.type === 'list' && node.listType === 'number'"
        class="list-decimal space-y-2 pl-6 marker:font-display marker:text-[var(--color-accent)]"
      >
        <li v-for="(item, j) in node.children" :key="j">
          <template v-for="(c, k) in item.children" :key="k">
            <span v-if="c.type === 'text'" :class="inlineClasses(c.format)">{{ c.text }}</span>
          </template>
        </li>
      </ol>

      <!-- Цитата -->
      <blockquote
        v-else-if="node.type === 'quote'"
        class="border-l-2 border-[var(--color-accent)] pl-6 font-display text-xl italic text-[var(--color-ink)]"
      >
        <template v-for="(child, j) in node.children" :key="j">
          <span :class="inlineClasses(child.format)">{{ child.text }}</span>
        </template>
      </blockquote>

      <!-- Горизонтальная линия -->
      <hr v-else-if="node.type === 'horizontalrule'" class="border-[var(--color-line)]" />

      <!-- Изображение (upload) -->
      <figure v-else-if="node.type === 'upload' && node.value?.url" class="!my-8">
        <NuxtImg
          :src="imgUrl(node.value.url)"
          :alt="node.value.alt || node.value.filename || ''"
          class="w-full rounded-[var(--radius-lg)] object-cover"
          sizes="(max-width: 768px) 100vw, 768px"
          format="webp,avif"
        />
        <figcaption v-if="node.value.alt" class="mt-2 text-sm text-[var(--color-ink-subtle)]">
          {{ node.value.alt }}
        </figcaption>
      </figure>

      <!-- Произвольный блок: рендерим детей рекурсивно -->
      <RichTextRenderer
        v-else-if="node.children?.length"
        :content="node.children"
        class="!space-y-0"
      />
    </template>
  </div>
</template>
