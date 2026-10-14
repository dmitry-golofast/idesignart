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

  nuxtApp.hook('app:mounted', () => {
    // Даём Vue отрисовать первый кадр, затем включаем наблюдение
    requestAnimationFrame(scan)
  })

  // SPA-навигация: новые страницы содержат новые data-reveal
  nuxtApp.hook('page:finish', () => {
    requestAnimationFrame(scan)
  })
})
