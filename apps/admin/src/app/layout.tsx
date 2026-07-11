import React from 'react'

/**
 * Корневой layout для Next.js.
 *
 * НЕ рендерим <html>/<body> здесь — Payload RootLayout (в (payload)/layout.tsx)
 * сам создаёт <html data-theme dir lang> и <body>.
 * Двойные теги приводят к hydration errors.
 *
 * Этот layout нужен только для не-Payload роутов (если они появятся).
 */
export const metadata = {
  title: 'idesignart Admin',
  description: 'Управление контентом сайта',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return children
}
