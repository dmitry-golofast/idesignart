import type { Page, Post, Project, Service, Setting } from './types/payload'

// Подтягиваем типы пакета payload в программу: без этого import type
// аугментация declare module 'payload' в types/payload.ts даёт TS2664
import type {} from 'payload'

/**
 * Хелперы над сгенерированными Payload-типами (shared/types/payload.ts).
 * Сам файл генерируется Payload'ом — дописывать типы туда нельзя, поэтому
 * ответы REST и глобальные настройки описываем здесь.
 */

/** Стандартный ответ Payload REST на выборку списка (PaginatedDocs). */
export interface Paginated<T> {
  docs: T[]
  totalDocs: number
  limit: number
  page?: number
  totalPages: number
  hasNextPage: boolean
  hasPrevPage: boolean
}

export type PagesResponse = Paginated<Page>
export type PostsResponse = Paginated<Post>
export type ProjectsResponse = Paginated<Project>
export type ServicesResponse = Paginated<Service>

// Globals в Payload типизируются как { value: Setting }
export type SettingsGlobal = Setting
