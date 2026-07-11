# ===== Next.js + Payload (admin) production Dockerfile =====

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
ENV NODE_OPTIONS=--max-old-space-size=768

RUN pnpm --filter admin build

# --- Этап 3: runtime ---
FROM node:22-alpine AS runtime
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3001
ENV HOSTNAME=0.0.0.0

# Standalone-сервер (создаётся Next.js при output: 'standalone')
COPY --from=builder /app/apps/admin/.next/standalone ./
# Static-файлы
COPY --from=builder /app/apps/admin/.next/static ./apps/admin/.next/static
# Директория для media (Payload uploads)
RUN mkdir -p /app/media

EXPOSE 3001

CMD ["node", "apps/admin/server.js"]
