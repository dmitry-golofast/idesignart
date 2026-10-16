/**
 * dev-watch — сторож для `pnpm dev` (только для разработки на Windows).
 *
 * nuxi dev на Windows изредка завершается нативно (exit 0xFFFFFFFF /
 * 0xC0000005) под штормом обрываемых прокси-запросов — без единой ошибки
 * в логе. Сторож просто поднимает стек заново через 2 секунды после
 * падения: обрыв на пару секунд вместо погибшей dev-сессии.
 *
 * Запуск: pnpm dev:watch. Выход — Ctrl+C (нажатие пробрасывается в pnpm,
 * сторож завершается вместе с ним, не успев перезапустить стек).
 */
import { spawn } from 'node:child_process'

// Коды, при которых перезапускать не нужно: пользователь остановил процесс
const NO_RESTART_CODES = new Set([
  0, // нормальный выход
  3221225786, // 0xC000013A — STATUS_CONTROL_C_EXIT (Ctrl+C на Windows)
])

let running = true

for (const sig of ['SIGINT', 'SIGTERM']) {
  process.on(sig, () => {
    running = false
    process.exit(0)
  })
}

while (running) {
  const child = spawn('pnpm', ['dev'], { stdio: 'inherit', shell: true })
  const code = await new Promise((resolve) => child.on('exit', (c) => resolve(c)))
  if (!running || NO_RESTART_CODES.has(code)) {
    console.log(`[dev-watch] pnpm dev завершён (code ${code}) — сторож останавливается`)
    break
  }
  console.log(`[dev-watch] pnpm dev упал (code ${code}) — перезапуск через 2с...`)
  await new Promise((resolve) => setTimeout(resolve, 2000))
}
