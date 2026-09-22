/**
 * Связи Payload приходят объектом при depth >= 1 и числом-ID при depth = 0.
 * Сужаем union (number | Media) до заселеченного объекта.
 * Автоимпортится Nuxt'ом (utils/).
 */
export function populated<T extends object>(rel: number | T | null | undefined): T | null {
  return rel !== null && typeof rel === 'object' ? rel : null
}
