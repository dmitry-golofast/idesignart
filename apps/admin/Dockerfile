# ===== Next.js + Payload (admin) production Dockerfile =====
# Без standalone — pnpm monorepo ломает standalone trace.
# Копируем полный проект с node_modules и запускаем через next start.

# --- Этап 1: зависимости ---
FROM node:22-alpine AS deps
RUN corepack enable && corepack prepare pnpm@9.15.0 --activate
WORKDIR /app

COPY package.json pnpm-workspace.yaml pnpm-lock.yaml ./
COPY apps/admin/package.json ./apps/admin/
COPY apps/payload/package.json ./apps/payload/
COPY packages/shared/package.json ./packages/shared/

RUN pnpm install --frozen-lockfile

# --- Этап 2: сборка ---
FROM node:22-alpine AS builder
RUN corepack enable && corepack prepare pnpm@9.15.0 --activate
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/apps/admin/node_modules ./apps/admin/node_modules
COPY --from=deps /app/apps/payload/node_modules ./apps/payload/node_modules

COPY package.json pnpm-workspace.yaml ./
COPY apps/admin ./apps/admin
COPY apps/payload ./apps/payload
COPY packages/shared ./packages/shared

ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
ENV NODE_OPTIONS=--max-old-space-size=1536

RUN pnpm --filter admin build

# --- Этап 3: runtime (полный образ с зависимостями) ---
FROM node:22-alpine AS runtime
RUN corepack enable && corepack prepare pnpm@9.15.0 --activate
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3001
ENV HOSTNAME=0.0.0.0

# Копируем ВСЁ — node_modules, собранный .next, конфиги
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/apps/admin/node_modules ./apps/admin/node_modules
COPY --from=builder /app/apps/payload/node_modules ./apps/payload/node_modules
COPY --from=builder /app/apps/admin/.next ./apps/admin/.next
COPY --from=builder /app/apps/admin/package.json ./apps/admin/package.json
COPY --from=builder /app/apps/admin/next.config.ts ./apps/admin/next.config.ts
COPY --from=builder /app/apps/admin/tsconfig.json ./apps/admin/tsconfig.json
COPY --from=builder /app/apps/payload ./apps/payload
COPY --from=builder /app/packages/shared ./packages/shared
COPY --from=builder /app/package.json /app/pnpm-workspace.yaml ./

# Директория для media (Payload uploads)
RUN mkdir -p /app/apps/admin/media

EXPOSE 3001

WORKDIR /app/apps/admin
CMD ["node", "../../node_modules/.bin/next", "start", "--port", "3001", "--hostname", "0.0.0.0"]
