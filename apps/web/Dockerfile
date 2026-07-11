# ===== Nuxt 4 production Dockerfile =====
# Многоэтапная сборка: install → build → runtime

# --- Этап 1: зависимости ---
FROM node:22-alpine AS deps
RUN corepack enable && corepack prepare pnpm@9.15.0 --activate
WORKDIR /app

# Копируем workspace-конфиги
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml ./
COPY apps/web/package.json ./apps/web/
COPY packages/shared/package.json ./packages/shared/

RUN pnpm install --frozen-lockfile

# --- Этап 2: сборка ---
FROM node:22-alpine AS builder
RUN corepack enable && corepack prepare pnpm@9.15.0 --activate
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/apps/web/node_modules ./apps/web/node_modules

COPY package.json pnpm-workspace.yaml ./
COPY apps/web ./apps/web
COPY packages/shared ./packages/shared

# Переменные для сборки (Nuxt подставит в runtime-config)
ENV NUXT_PUBLIC_SITE_URL=https://idesignart.ru
ENV NUXT_PUBLIC_PAYLOAD_API_URL=https://admin.idesignart.ru
# Лимит heap для Nuxt build (Nitro требует ~1.1GB в пике)
ENV NODE_OPTIONS=--max-old-space-size=1536

RUN pnpm --filter web build

# --- Этап 3: runtime (минимальный образ) ---
FROM node:22-alpine AS runtime
WORKDIR /app

# Только production-зависимости + собранный output
COPY --from=builder /app/apps/web/.output ./.output
COPY --from=builder /app/apps/web/package.json ./package.json

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
