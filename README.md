# idesignart

Студия дизайна интерьера и 3D-визуализации. Сайт для привлечения клиентов
(дизайн квартиры, офиса, пространства, 3D-визуализация).

## Стек

| Слой | Технология |
|------|------------|
| Frontend (сайт) | Nuxt 4 + TypeScript + Tailwind CSS v4 + Nuxt UI v4 |
| Admin (CMS UI + API) | Next.js 15 + @payloadcms/next |
| CMS | Payload 3 (headless: schema + REST/GraphQL) |
| DB | PostgreSQL |

## Архитектура (3 приложения)

```
idesignart/
├── apps/
│   ├── payload/     ← Schema + config (коллекции, глобалы, типы)
│   ├── admin/       ← Next.js: Payload admin UI + REST/GraphQL API (:3001)
│   └── web/         ← Nuxt 4: публичный сайт (:3000)
├── packages/
│   └── shared/types/← Общие TypeScript-типы (генерируются из Payload)
├── docs/
│   └── REFERENCES_AND_STRATEGY.md
└── pnpm-workspace.yaml
```

**Поток данных:** Nuxt (frontend) → REST API (`/api/*`) → Payload (admin app) → PostgreSQL

## Быстрый старт

> **Требование:** запущенный Docker Desktop (для PostgreSQL)

```bash
# 1. Установить зависимости
pnpm install

# 2. Скопировать env
cp .env.example .env
#   → заполнить PAYLOAD_SECRET (32+ случайных символа)

# 3. Поднять базу
docker compose up -d postgres

# 4. Сгенерировать типы Payload
pnpm --filter payload generate:types

# 5. Запустить admin (CMS) и сайт
pnpm --filter admin dev   # → http://localhost:3001/admin
pnpm --filter web dev     # → http://localhost:3000
```

## URL-ы

| URL | Что |
|-----|-----|
| http://localhost:3000 | **Nuxt** — публичный сайт |
| http://localhost:3001/admin | **Payload admin** — управление контентом |
| http://localhost:3001/api | **REST API** (Payload) |
| http://localhost:3001/api/graphql | **GraphQL** playground (Payload) |

## Первый вход в админку

1. Откройте http://localhost:3001/admin
2. При первом запуске Payload предложит создать администратора
3. Создайте пользователя (email + пароль)
4. Войдите — откроется дашборд со всеми коллекциями

## Команды

| Команда | Описание |
|---------|----------|
| `pnpm install` | Установить все зависимости |
| `pnpm --filter admin dev` | Запустить Payload admin + API (:3001) |
| `pnpm --filter web dev` | Запустить Nuxt — сайт (:3000) |
| `pnpm --filter payload generate:types` | Типы → `packages/shared/types/payload.ts` |
| `pnpm --filter web build` | Сборка Nuxt |
| `pnpm --filter admin build` | Сборка admin (Next.js) |
| `pnpm --filter web typecheck` | Проверка типов Nuxt |

## Если Docker недоступен

Payload admin требует PostgreSQL. Без БД:
- `http://localhost:3001/admin` вернёт ошибку 500
- Nuxt-сайт поднимется, но данные из CMS не загрузятся

Решения:
1. Запустите Docker Desktop → `docker compose up -d postgres`
2. Или установите PostgreSQL локально
3. Или используйте облачную БД (Neon, Supabase, Railway)
