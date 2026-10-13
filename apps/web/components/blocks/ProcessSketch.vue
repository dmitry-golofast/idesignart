<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'

/**
 * ProcessSketch — процедурный чертёж на canvas.
 * Рисует карандашный набросок (тонкие линии с лёгкой «дрожью» руки)
 * в нормализованной системе координат 760×460, масштабируется в контейнер.
 * Палитра дублирует токены сайта (tokens.css), чтобы не тянуть CSS в canvas.
 */
const props = defineProps<{
  type: 'plan' | 'iso' | 'elevation' | 'perspective'
}>()

const INK = '#1a1816' // --color-ink
const MUTED = '#6b6660' // --color-ink-muted
const LINE = '#b8b0a4' // затемнённый --color-line для читаемости на бумаге

const canvasRef = ref<HTMLCanvasElement | null>(null)
let ro: ResizeObserver | null = null

/* --- «рука»: детерминированная дрожь линий --- */
let seed = 42
function rnd() {
  seed = (seed * 16807) % 2147483647
  return (seed / 2147483647 - 0.5) * 2
}

function sketchLine(ctx: CanvasRenderingContext2D, x1: number, y1: number, x2: number, y2: number, wobble = 1.4) {
  const dx = x2 - x1
  const dy = y2 - y1
  const len = Math.hypot(dx, dy) || 1
  const nx = -dy / len
  const ny = dx / len
  const steps = Math.max(3, Math.round(len / 42))
  ctx.beginPath()
  ctx.moveTo(x1, y1)
  for (let i = 1; i <= steps; i++) {
    const t = i / steps
    const o = i === steps ? 0 : rnd() * wobble
    ctx.lineTo(x1 + dx * t + nx * o, y1 + dy * t + ny * o)
  }
  ctx.stroke()
}

function sketchRect(ctx: CanvasRenderingContext2D, x: number, y: number, w: number, h: number) {
  sketchLine(ctx, x, y, x + w, y)
  sketchLine(ctx, x + w, y, x + w, y + h)
  sketchLine(ctx, x + w, y + h, x, y + h)
  sketchLine(ctx, x, y + h, x, y)
}

function sketchPolyline(ctx: CanvasRenderingContext2D, pts: [number, number][], close = false) {
  for (let i = 0; i < pts.length - 1; i++) {
    const a = pts[i]
    const b = pts[i + 1]
    if (!a || !b) continue
    sketchLine(ctx, a[0], a[1], b[0], b[1])
  }
  const first = pts[0]
  const last = pts[pts.length - 1]
  if (close && first && last) sketchLine(ctx, last[0], last[1], first[0], first[1])
}

/** Размерная линия: выноски, стрелки-штрихи, подпись по центру */
function dimension(ctx: CanvasRenderingContext2D, x1: number, x2: number, y: number, label: string) {
  ctx.strokeStyle = MUTED
  ctx.lineWidth = 1
  sketchLine(ctx, x1, y - 6, x2, y - 6)
  // выносные и засечки
  for (const x of [x1, x2]) {
    sketchLine(ctx, x, y - 12, x, y)
    sketchLine(ctx, x - 5, y - 11, x + 5, y - 1)
  }
  ctx.fillStyle = MUTED
  ctx.font = '500 13px "JetBrains Mono", ui-monospace, monospace'
  ctx.textAlign = 'center'
  ctx.fillText(label, (x1 + x2) / 2, y - 13)
}

function label(ctx: CanvasRenderingContext2D, text: string, x: number, y: number, align: CanvasTextAlign = 'left') {
  ctx.fillStyle = MUTED
  ctx.font = '500 13px "JetBrains Mono", ui-monospace, monospace'
  ctx.textAlign = align
  ctx.fillText(text, x, y)
}

/* --- четыре чертежа --- */

function drawPlan(ctx: CanvasRenderingContext2D) {
  // стены (двойной контур)
  ctx.lineWidth = 1.6
  ctx.strokeStyle = INK
  sketchRect(ctx, 130, 90, 500, 290)
  sketchRect(ctx, 138, 98, 484, 274)

  // окна на верхней стене
  for (const wx of [180, 290, 400]) {
    sketchRect(ctx, wx, 84, 58, 12)
    sketchLine(ctx, wx + 29, 84, wx + 29, 96)
  }

  // внутренняя стена с проёмом и дверью
  sketchLine(ctx, 400, 98, 400, 210)
  sketchLine(ctx, 400, 258, 400, 372)
  ctx.beginPath()
  ctx.arc(400, 210, 48, -Math.PI / 2, 0)
  ctx.stroke()
  sketchLine(ctx, 400, 258, 448, 258)

  // мебель: диван, стол, кровать
  sketchRect(ctx, 165, 290, 130, 58)
  sketchLine(ctx, 165, 306, 295, 306)
  ctx.beginPath()
  ctx.arc(500, 165, 38, 0, Math.PI * 2)
  ctx.stroke()
  sketchRect(ctx, 445, 275, 155, 70)
  sketchLine(ctx, 445, 297, 600, 297)

  dimension(ctx, 130, 630, 62, '3 000')
  dimension(ctx, 130, 630, 418, '6 000')
}

function drawIso(ctx: CanvasRenderingContext2D) {
  ctx.lineWidth = 1.6
  ctx.strokeStyle = INK
  // комната: пол и две стены
  sketchPolyline(ctx, [
    [150, 200], [150, 350], [380, 420], [620, 340], [620, 190],
    [380, 120], [150, 200],
  ])
  sketchLine(ctx, 150, 350, 380, 420)
  sketchLine(ctx, 150, 350, 380, 285)
  sketchLine(ctx, 380, 420, 380, 285)
  sketchLine(ctx, 380, 285, 620, 190)
  sketchLine(ctx, 380, 120, 380, 285)

  // окно на левой стене
  sketchPolyline(ctx, [[190, 210], [250, 193], [250, 268], [190, 285]], true)
  sketchLine(ctx, 220, 202, 220, 277)
  sketchLine(ctx, 190, 247, 250, 230)

  // кровать: низкий бокс
  sketchPolyline(ctx, [[420, 300], [540, 262], [600, 282], [480, 322]], true)
  sketchPolyline(ctx, [[420, 300], [420, 330], [480, 352], [480, 322]])
  sketchPolyline(ctx, [[480, 322], [480, 352], [600, 312], [600, 282]])
  sketchLine(ctx, 435, 300, 448, 262)
  sketchLine(ctx, 448, 262, 470, 268)

  // ковёр
  ctx.save()
  ctx.translate(330, 385)
  ctx.scale(1, 0.32)
  ctx.beginPath()
  ctx.arc(0, 0, 85, 0, Math.PI * 2)
  ctx.stroke()
  ctx.beginPath()
  ctx.arc(0, 0, 62, 0, Math.PI * 2)
  ctx.stroke()
  ctx.restore()

  label(ctx, 'ИЗО 30°', 600, 130, 'right')
}

function drawElevation(ctx: CanvasRenderingContext2D) {
  ctx.lineWidth = 1.6
  ctx.strokeStyle = INK
  // стена и пол
  sketchLine(ctx, 130, 150, 630, 150)
  sketchLine(ctx, 130, 350, 630, 350)
  sketchLine(ctx, 130, 150, 130, 350)
  sketchLine(ctx, 630, 150, 630, 350)

  // окна
  for (const wx of [155, 268, 381, 494]) {
    sketchRect(ctx, wx, 195, 92, 110)
    sketchLine(ctx, wx + 46, 195, wx + 46, 305)
    sketchLine(ctx, wx, 250, wx + 92, 250)
    sketchLine(ctx, wx - 6, 305, wx + 98, 305)
  }

  // светильники
  for (const cx of [220, 380, 540]) {
    sketchLine(ctx, cx, 150, cx, 126)
    ctx.beginPath()
    ctx.arc(cx, 116, 10, 0, Math.PI * 2)
    ctx.stroke()
  }

  // штриховка пола
  for (let x = 145; x < 625; x += 26) sketchLine(ctx, x, 350, x - 12, 364)

  dimension(ctx, 130, 630, 105, '3 200')
  label(ctx, 'РАЗВЕРТКА А-А', 380, 408, 'center')
}

function drawPerspective(ctx: CanvasRenderingContext2D) {
  ctx.lineWidth = 1.6
  ctx.strokeStyle = INK
  // задняя стена
  sketchRect(ctx, 295, 155, 180, 190)
  // линии схода к краям листа
  sketchLine(ctx, 120, 70, 295, 155)
  sketchLine(ctx, 640, 70, 475, 155)
  sketchLine(ctx, 120, 420, 295, 345)
  sketchLine(ctx, 640, 420, 475, 345)
  sketchLine(ctx, 120, 70, 120, 420)
  sketchLine(ctx, 640, 70, 640, 420)

  // окно на задней стене
  sketchRect(ctx, 335, 180, 100, 78)
  sketchLine(ctx, 385, 180, 385, 258)
  sketchLine(ctx, 335, 219, 435, 219)

  // стол слева с ножками
  sketchPolyline(ctx, [[130, 330], [295, 305], [295, 322], [130, 350]], true)
  sketchLine(ctx, 145, 352, 145, 395)
  sketchLine(ctx, 285, 324, 285, 362)

  // лампа
  sketchLine(ctx, 200, 330, 200, 250)
  sketchLine(ctx, 200, 250, 222, 262)
  ctx.beginPath()
  ctx.arc(200, 250, 14, Math.PI * 0.15, Math.PI * 0.95)
  ctx.stroke()

  // растение справа
  sketchPolyline(ctx, [[560, 360], [548, 415], [596, 415], [585, 360]], true)
  for (const [x2, y2] of [[556, 300], [578, 288], [600, 305], [566, 315]] as const) {
    sketchLine(ctx, 572, 360, x2, y2)
    ctx.beginPath()
    ctx.arc(x2, y2, 7, 0, Math.PI * 2)
    ctx.stroke()
  }

  // ковёр
  ctx.save()
  ctx.translate(385, 385)
  ctx.scale(1, 0.3)
  ctx.beginPath()
  ctx.arc(0, 0, 95, 0, Math.PI * 2)
  ctx.stroke()
  ctx.restore()
}

const DRAWERS: Record<string, (ctx: CanvasRenderingContext2D) => void> = {
  plan: drawPlan,
  iso: drawIso,
  elevation: drawElevation,
  perspective: drawPerspective,
}

function draw() {
  const el = canvasRef.value
  if (!el) return
  const dpr = Math.min(window.devicePixelRatio || 1, 2)
  const w = el.clientWidth
  const h = el.clientHeight
  if (!w || !h) return
  el.width = Math.round(w * dpr)
  el.height = Math.round(h * dpr)
  const ctx = el.getContext('2d')
  if (!ctx) return
  ctx.scale(dpr, dpr)
  ctx.clearRect(0, 0, w, h)
  ctx.lineCap = 'round'
  ctx.lineJoin = 'round'
  seed = 42
  // нормализованный листинг 760×460 → вписываем в контейнер
  const s = Math.min(w / 760, h / 460)
  ctx.translate((w - 760 * s) / 2, (h - 460 * s) / 2)
  ctx.scale(s, s)
  DRAWERS[props.type]?.(ctx)
}

onMounted(() => {
  draw()
  ro = new ResizeObserver(() => draw())
  if (canvasRef.value) ro.observe(canvasRef.value)
})
onBeforeUnmount(() => ro?.disconnect())
watch(() => props.type, draw)
</script>

<template>
  <canvas ref="canvasRef" class="block h-full w-full" aria-hidden="true" />
</template>
