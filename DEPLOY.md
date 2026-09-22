# Деплой на Ubuntu VPS

> Пошаговая инструкция деплоя idesignart на Ubuntu 22.04/24.04 LTS
> Подходит для: Timeweb Cloud, Hetzner, DigitalOcean, Beget, любого VPS

---

## Архитектура

```
Интернет
    │
    ▼
┌────────────────────────────────────────────────────────┐
│  Caddy (:80, :443)  ← auto SSL (Let's Encrypt)           │
│  idesignart.com:                                         │
│    ├─ /admin, /api, /media, /graphql → admin:3001 (CMS)  │
│    └─ всё остальное                  → web:3000  (Nuxt)  │
│  www.idesignart.com              → редирект на основной  │
│  admin.idesignart.com            → 308 на основной       │
│                                    (временный, см. ниже) │
└────────────────────────────────────────────────────────┘
    │                              │
    ▼                              ▼
┌──────────┐               ┌──────────────┐
│  Nuxt    │               │  Next.js +   │
│  (:3000) │               │  Payload     │
│          │               │  (:3001)     │
└──────────┘               └──────────────┘
                                 │
                                 ▼
                          ┌──────────────┐
                          │ PostgreSQL   │
                          │ (:5432)      │
                          └──────────────┘
```

Админка, API и медиа живут на основном домене по путям `/admin`, `/api`, `/media`.
Отдельный поддомен `admin.idesignart.com` больше не нужен: Caddy держит для него
временный 308-редирект, чтобы старые ссылки и зашитые URL медиа продолжали работать.
Когда уверены, что старых ссылок не осталось (обычно через месяц-два), удалите блок
`{$ADMIN_DOMAIN}` из Caddyfile и DNS-запись `A admin`.

---

## Шаг 0. Требования к серверу

| Параметр | Минимум | Рекомендуется |
|----------|---------|---------------|
| CPU | 1 vCPU | 2 vCPU |
| RAM | 2 GB | 4 GB |
| Disk | 20 GB | 40 GB SSD |
| OS | Ubuntu 22.04 LTS | Ubuntu 24.04 LTS |

## Шаг 1. DNS-записи

Перед деплоем настройте DNS у вашего регистратора домена:

| Тип | Имя | Значение | Описание |
|-----|-----|----------|----------|
| A | `@` | `IP_ВАШЕГО_СЕРВЕРА` | Основной домен (сайт + админка) |
| A | `www` | `IP_ВАШЕГО_СЕРВЕРА` | Редирект |
| A | `admin` | `IP_ВАШЕГО_СЕРВЕРА` | Опционально: только если нужен редирект старых ссылок |

Проверьте: `dig idesignart.com` должен вернуть IP вашего сервера.

---

## Шаг 2. Подготовка сервера

Подключитесь к серверу по SSH:

```bash
ssh root@IP_ВАШЕГО_СЕРВЕРА
```

### Установка Docker + Docker Compose

```bash
# Обновление системы
apt update && apt upgrade -y

# Установка Docker
curl -fsSL https://get.docker.com | sh

# Проверка
docker --version
docker compose version
```

### Создание пользователя (не работайте под root)

```bash
adduser deploy
usermod -aG sudo deploy
usermod -aG docker deploy

# Переключение
su - deploy
```

### Настройка файрвола

```bash
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

---

## Шаг 3. Клонирование проекта

```bash
cd /home/deploy
git clone https://github.com/ВАШ-РЕПОЗИТОРИЙ/idesignart.git
cd idesignart
```

---

## Шаг 4. Настройка окружения

```bash
cp .env.production.example .env.production
nano .env.production
```

Заполните:

```env
SITE_DOMAIN=idesignart.com
# Опционально: только если держите редирект со старого админ-поддомена
ADMIN_DOMAIN=admin.idesignart.com

# Сгенерируйте секрет:
openssl rand -hex 32
# → вставьте результат в PAYLOAD_SECRET

PAYLOAD_SECRET=ваш_сгенерированный_секрет
DB_PASSWORD=надёжный_пароль_для_БД
```

⚠️ **Обязательно измените `DB_PASSWORD` и `PAYLOAD_SECRET`!**

---

## Шаг 5. Сборка и запуск

```bash
# Сборка Docker-образов (5–15 минут)
docker compose -f docker-compose.prod.yml build

# Запуск всех сервисов
docker compose -f docker-compose.prod.yml up -d

# Проверка статуса
docker compose -f docker-compose.prod.yml ps
```

Все сервисы должны быть `running` или `healthy`.

### Проверка логов

```bash
# Логи всех сервисов
docker compose -f docker-compose.prod.yml logs -f

# Логи конкретного сервиса
docker compose -f docker-compose.prod.yml logs -f web
docker compose -f docker-compose.prod.yml logs -f admin
docker compose -f docker-compose.prod.yml logs -f caddy
```

---

## Шаг 6. Проверка

Откройте в браузере:

| URL | Что должно быть |
|-----|-----------------|
| `https://idesignart.com` | Nuxt-сайт (SSL автоматически) |
| `https://idesignart.com/admin` | Payload CMS — создание админа |
| `https://idesignart.com/api` | REST API |

SSL-сертификат выдаётся автоматически (~30 секунд после первого запроса).

### Первый вход в админку

1. `https://idesignart.com/admin`
2. Создайте администратора (email + пароль)
3. Откройте **Pages → Home** → добавьте блоки
4. Опубликуйте → сайт наполнится контентом

---

## Шаг 7. Обновления

При пуше нового кода:

```bash
cd /home/deploy/idesignart
git pull origin main

# Пересборка и перезапуск
docker compose -f docker-compose.prod.yml up -d --build
```

---

## Миграция существующего сервера (переезд на один домен)

Если сервер уже работал со схемой `admin.idesignart.com`, при первом деплое
этой версии сделайте дополнительно:

**1. Перенесите загрузки медиа в volume.** Раньше `staticDir` указывал на
`/app/apps/admin/media` внутри контейнера (слой контейнера, теряется при
пересборке), а volume монтировался в `/app/media`. Теперь volume монтируется
правильно, но старые файлы нужно перенести один раз:

```bash
# Пока СТАРЫЙ контейнер admin ещё работает:
docker cp idesignart-admin:/app/apps/admin/media/. idesignart-admin:/app/media/

# После этого: git pull + docker compose -f docker-compose.prod.yml up -d --build
```

**2. Проверьте контент на абсолютные ссылки старого домена** (обычно их нет —
Payload вычисляет URL медиа от `serverURL` на лету, но rich-text-поля стоит
проверить):

```bash
docker exec idesignart-db pg_dump -U postgres idesignart | grep -c 'admin\.idesignart'
# 0 — чисто; если больше — см. ниже
```

Если находки есть — ссылки всё равно продолжат работать через временный
308-редирект старого домена; починить можно точечным `UPDATE ... replace(...)`.

**3. Проверьте после деплоя:**

- `https://SITE/admin` открывает админку;
- картинки на сайте грузятся с `https://SITE/media/...`;
- `curl -I https://admin.SITE/media/<файл>` отдаёт 308 редирект.

---

## Миграции БД

Схема Payload версонируется миграциями в `apps/payload/src/migrations/`.
Контент миграции **не переносят** — только структуру таблиц. Контент живёт
в базе и переезжает через `pg_dump`/`pg_restore` (см. «Бэкапы»).

### Как это работает

- **Dev**: схема применяется автоматически при старете (`push` через drizzle-kit).
  Если локальная база разошлась с кодом, dev спросит интерактивно — выбирайте
  «create column», никогда не «rename» (либо сбросьте дев-базу: `docker compose down -v && docker compose up -d`).
- **Production**: миграции **сами не запускаются** — применяется вручную командой ниже.

### Создать новую миграцию (нужен запущенный локальный postgres)

```bash
pnpm migrate:create "суть изменения"
# файл появится в apps/payload/src/migrations/, закоммитьте его вместе с кодом
```

### Применить миграции на проде (после деплоя нового кода)

```bash
docker exec -w /app/apps/payload idesignart-admin npx payload migrate
```

⚠️ Перед применением — бэкап: `docker exec idesignart-db pg_dump -U postgres idesignart > backup_$(date +%Y%m%d).sql`

### Разовый фикс для СУЩЕСТВУЮЩЕГО прода при первом деплое миграций

Если прод-база уже работает и её схема соответствует коду (контент сохраняется
из админки без ошибок), базовую миграцию **выполнять не нужно** — достаточно
пометить её применённой, чтобы будущие миграции применялись поверх:

```bash
docker exec idesignart-db psql -U postgres -d idesignart -c "
CREATE TABLE IF NOT EXISTS payload_migrations (
  id serial PRIMARY KEY,
  name varchar NOT NULL,
  batch numeric NOT NULL,
  updated_at timestamp(3) with time zone DEFAULT now() NOT NULL,
  created_at timestamp(3) with time zone DEFAULT now() NOT NULL
);
INSERT INTO payload_migrations (name, batch, created_at, updated_at)
VALUES ('20260922_091233_initial_schema', 1, now(), now());"
```

Для **нового** сервера с нуля: после первого `up -d` выполните
`docker exec -w /app/apps/payload idesignart-admin npx payload migrate`
до наполнения контента.

---

## Бэкапы

### База данных

```bash
# Создать бэкап
docker exec idesignart-db pg_dump -U postgres idesignart > backup_$(date +%Y%m%d).sql

# Восстановить
cat backup_20260101.sql | docker exec -i idesignart-db psql -U postgres idesignart
```

### Cron — автоматический бэкап каждый день

```bash
crontab -e
```

Добавьте:

```cron
0 3 * * * docker exec idesignart-db pg_dump -U postgres idesignart > /home/deploy/backups/db_$(date +\%Y\%m\%d).sql
```

---

## Полезные команды

```bash
# Остановить всё
docker compose -f docker-compose.prod.yml down

# Остановить и удалить volumes (ОСТОРОЖНО — удалит БД!)
docker compose -f docker-compose.prod.yml down -v

# Перезапустить один сервис
docker compose -f docker-compose.prod.yml restart web

# Зайти в контейнер
docker exec -it idesignart-web sh
docker exec -it idesignart-admin sh

# Посмотреть место на диске
docker system df

# Очистка неиспользуемых образов
docker system prune -a
```

---

## Частые проблемы

### Сайт не открывается (502 Bad Gateway)

```bash
# Проверить, запустился ли Nuxt
docker logs idesignart-web --tail 20

# Перезапустить
docker compose -f docker-compose.prod.yml restart web
```

### Админка Payload — 500 / Cannot connect to database

```bash
# Проверить PostgreSQL
docker logs idesignart-db --tail 20

# Проверить подключение из admin
docker exec idesignart-admin node -e "
  const { Client } = require('pg');
  const c = new Client(process.env.DATABASE_URI);
  c.connect().then(() => { console.log('DB OK'); process.exit(0) }).catch(e => { console.log('DB ERROR:', e.message); process.exit(1) });
"
```

### SSL не работает

```bash
# Проверить Caddy
docker logs idesignart-caddy --tail 30

# DNS должен указывать на этот сервер
dig idesignart.com
# Должен вернуть IP сервера
```

### Not enough memory

```bash
# Добавить swap (если RAM < 4GB)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```
