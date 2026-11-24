/**
 * reveal — система появления блоков при скролле (язык ayocin.com).
 *
 * Разметка носит атрибут data-reveal (варианты: '', 'fade', 'left',
 * 'right', 'zoom') или data-reveal-line (маска-строки для заголовков).
 * Плагин находит такие элементы после гидратации и добавляет .is-revealed,
 * когда элемент входит в viewport. До гидратации элементы скрыты только
 * при наличии класса .has-js на <html> (его ставит inline-скрипт из head),
 * поэтому без JS контент полностью виден.
 *
 * Задержка каскада — через CSS-переменную на элементе:
 *   style="--reveal-delay: 120ms"
 */

const REVEAL_SELECTOR = '[data-reveal], [data-reveal-line]'

export default defineNuxtPlugin((nuxtApp) => {
  if (import.meta.server) return

  let observer: IntersectionObserver | null = null

  const ensureObserver = () => {
    if (observer) return observer
    observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (!entry.isIntersecting) continue
          entry.target.classList.add('is-revealed')
          observer?.unobserve(entry.target)
        }
      },
      {
        // Срабатывание чуть раньше полного входа — появление чувствуется
        // во время скролла, а не после остановки. Порог небольшой: элементы
        // у нижней кромки (например CTA в hero) тоже должны раскрываться
        rootMargin: '0px 0px -4% 0px',
        threshold: 0.05,
      },
    )
    return observer
  }

  const scan = () => {
    const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches
    const els = document.querySelectorAll<HTMLElement>(
      '[data-reveal]:not(.is-revealed), [data-reveal-line]:not(.is-revealed)',
    )
    if (reduced) {
      els.forEach((el) => el.classList.add('is-revealed'))
      return
    }
    const obs = ensureObserver()
    els.forEach((el) => obs.observe(el))
  }

  // Один скан на кадр, сколько бы мутаций ни пришло
  let scheduled = false
  const scheduleScan = () => {
    if (scheduled) return
    scheduled = true
    requestAnimationFrame(() => {
      scheduled = false
      scan()
    })
  }

  // Первичный скан — после гидратации страницы. app:mounted для этого рано:
  // контент <NuxtPage> гидратируется позже, и класс попадал в ещё не
  // гидратированные узлы («Hydration class mismatch»).
  nuxtApp.hook('page:finish', () => {
    scheduleScan()
  })

  // SPA-навигация: при pageTransition с mode: 'out-in' page:finish вызывается,
  // когда новая страница ещё не вставлена в DOM (она ждёт окончания анимации
  // ухода старой), и скан захватывал только уходящую страницу — новая
  // оставалась навсегда скрытой (data-reveal без .is-revealed). Поэтому скан
  // привязан к факту вставки узлов; наблюдение покрывает и страницы после
  // перехода, и данные, пришедшие позже, и модалки.
  new MutationObserver((mutations) => {
    for (const mutation of mutations) {
      for (const node of mutation.addedNodes) {
        if (!(node instanceof Element)) continue
        if (node.matches(REVEAL_SELECTOR) || node.querySelector(REVEAL_SELECTOR)) {
          scheduleScan()
          return
        }
      }
    }
  }).observe(document.documentElement, { childList: true, subtree: true })
})
