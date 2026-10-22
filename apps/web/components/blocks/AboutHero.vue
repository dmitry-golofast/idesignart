<script setup lang="ts">
import type { Media } from '#shared/types/payload'

/**
 * AboutHero — шапка страницы «О студии»: текст слева, фото справа,
 * под фото — цитата основателя. Контент из CMS (блок about-hero страницы
 * slug=about); все поля опциональны — при пустых работают дефолты,
 * без фото — декоративная эспрессо-панель, без цитаты — блок скрывается.
 * Оформление — дизайн-токены tokens.css + scoped-стили, в CMS не живёт.
 */

const props = defineProps<{
  title?: string | null
  description?: string | null
  photo?: Media | number | null
  photoAlt?: string | null
  quote?: string | null
  quoteAuthor?: string | null
  quoteRole?: string | null
  // Игнорируем технические props от PageSections
  id?: string
  blockType?: string
}>()

const payloadBase = useRuntimeConfig().public.payloadApiUrl as string

/* ---------- безопасное чтение полей CMS ---------- */
const str = (v: unknown, d: string) => (typeof v === 'string' && v.length > 0 ? v : d)

const titleText = computed(() =>
  str(props.title, 'Создаём пространства, в которых хочется жить и работать'),
)
const descriptionText = computed(
  () =>
    str(
      props.description,
      'idesignart — студия дизайна интерьера и 3D-визуализации. Мы проектируем квартиры, дома и общественные пространства, объединяя эстетику и функциональность.',
    ),
)

const photoMedia = computed(() => populated(props.photo ?? null))
const photoUrl = computed(() => {
  const url = photoMedia.value?.url
  if (!url) return null
  return url.startsWith('http') ? url : `${payloadBase}${url}`
})
const photoAltText = computed(() =>
  str(props.photoAlt, photoMedia.value?.alt || 'Интерьер студии idesignart'),
)

const quoteText = computed(() => str(props.quote, ''))
const quoteAuthorText = computed(() => str(props.quoteAuthor, ''))
const quoteRoleText = computed(() => str(props.quoteRole, ''))
</script>

<template>
  <section class="about-hero bg-[var(--color-surface)]">
    <div class="container-app about-hero-inner">
      <div class="grid items-center gap-12 lg:grid-cols-[1.1fr_0.9fr] lg:min-h-0 lg:flex-1 lg:gap-16">
        <!-- Текст слева -->
        <div data-reveal>
          <h1 class="page-title">{{ titleText }}</h1>
          <p class="mt-6 max-w-xl text-lg leading-relaxed text-[var(--color-ink-muted)]">
            {{ descriptionText }}
          </p>
          <NuxtLink to="/portfolio" class="about-portfolio-link mt-8">
            Смотреть портфолио
            <span aria-hidden="true">→</span>
          </NuxtLink>
        </div>

        <!-- Фото справа + цитата основателя под ним; на десктопе колонка
             тянется на высоту грида (текст центрирован), фото занимает
             всю высоту колонки над цитатой -->
        <div class="flex flex-col lg:min-h-0 lg:self-stretch">
          <div
            class="about-photo aspect-[4/5] lg:aspect-auto lg:min-h-0 lg:flex-1"
            data-reveal="fade"
            style="--reveal-delay: 120ms"
          >
            <!-- Абсолютное позиционирование: натуральная высота img не
                 распирает flex-колонку (высоту панели диктует раскладка) -->
            <NuxtImg
              v-if="photoUrl"
              :src="photoUrl"
              :alt="photoAltText"
              sizes="sm:100vw lg:45vw"
              format="webp,avif"
              class="absolute inset-0 h-full w-full object-cover"
            />
            <!-- Без фото в CMS — декоративная эспрессо-панель -->
            <div v-else class="about-photo-fallback absolute inset-0" aria-hidden="true">
              <span class="font-display font-bold">idesignart</span>
            </div>
          </div>

          <figure
            v-if="quoteText"
            class="mt-7 flex-none border-l-2 border-[var(--color-gold)] pl-5"
            data-reveal
            style="--reveal-delay: 240ms"
          >
            <blockquote class="font-display text-[1.125rem] leading-snug font-semibold tracking-[-0.01em] text-[var(--color-ink)]">
              {{ quoteText }}
            </blockquote>
            <figcaption class="mt-3">
              <span v-if="quoteAuthorText" class="text-sm font-semibold text-[var(--color-ink)]">
                {{ quoteAuthorText }}
              </span>
              <span v-if="quoteRoleText" class="text-sm text-[var(--color-ink-muted)]">
                {{ quoteAuthorText ? ' · ' : '' }}{{ quoteRoleText }}
              </span>
            </figcaption>
          </figure>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Полноэкранная глава: минимум один вьюпорт МИНУС sticky-шапка (она
   занимает поток над блоком — эту величину из вьюпорта вычитают блоки
   первого экрана, см. комментарий у --header-height в tokens.css).
   min-height, а не height: на мобильных контент выше вьюпорта, секция
   растягивается и цитата не обрезается */
.about-hero {
  position: relative;
  display: flex;
  flex-direction: column;
  min-height: calc(100vh - var(--header-height, 76px));
  min-height: calc(100svh - var(--header-height, 76px));
  min-height: calc(100dvh - var(--header-height, 76px));
  /* Шапка прилипает и перекрывает верхние 76px — контент начинается под ней */
  padding-top: clamp(1.5rem, 4vh, 3rem);
  padding-bottom: clamp(1.25rem, 3vh, 2.5rem);
}

.about-hero-inner {
  flex: 1 1 auto;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

/* Ссылка на портфолио в тексте: hairline-подчёркивание как у пунктов
   меню шапки (.hd-link) — проявляется при наведении, стрелка двигается */
.about-portfolio-link {
  position: relative;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  width: fit-content;
  font-size: 0.9375rem;
  font-weight: 600;
  color: var(--color-ink);
  text-decoration: none;
}

.about-portfolio-link::after {
  content: "";
  position: absolute;
  left: 0;
  bottom: -5px;
  width: 100%;
  height: 1px;
  background-color: var(--color-ink);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform var(--duration-base) var(--ease-premium);
}

.about-portfolio-link:hover::after,
.about-portfolio-link:focus-visible::after {
  transform: scaleX(1);
}

.about-portfolio-link span {
  transition: transform var(--duration-base) var(--ease-premium);
}

.about-portfolio-link:hover span {
  transform: translateX(3px);
}

.about-portfolio-link:focus-visible {
  outline: 2px solid var(--color-ink);
  outline-offset: 4px;
}

/* Фото-панель: на десктопе заполняет высоту колонки над цитатой
   (пропорции управляют только мобильной раскладкой), скругление
   как у карточек проекта */
.about-photo {
  position: relative;
  overflow: hidden;
  border-radius: var(--radius-lg);
  background-color: var(--color-surface-alt);
}

/* Фолбэк без фото: эспрессо-градиент с призрачным брендом */
.about-photo-fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  background: radial-gradient(
    120% 90% at 70% 20%,
    var(--color-espresso-soft),
    var(--color-espresso)
  );
  color: rgba(246, 241, 231, 0.14);
  font-size: clamp(2rem, 4vw, 3.25rem);
  letter-spacing: -0.03em;
}
</style>
