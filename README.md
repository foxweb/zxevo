# ZX Evolution

Rails-приложение: блог, статические страницы и админ-панель.

## Возможности

- **Блог** — посты с CKEditor, лента RSS
- **Страницы** — редактируемые страницы по slug (например `/about`, `docs/faq`)
- **Админка** — Rails Admin на `/admin`
- **Авторизация** — Devise (вход/регистрация)

## Требования

- Docker и Docker Compose **или**
- Ruby 3.3.4, MySQL 8.x, Node.js (для сборки ассетов)
- **ImageMagick** (утилиты `identify` / `convert`) — для загрузки картинок в CKEditor (MiniMagick). В Docker образе пакет `imagemagick` уже ставится; на macOS: `brew install imagemagick`, на Debian/Ubuntu: `apt install imagemagick`.

### RailsAdmin и JavaScript

В RailsAdmin 3 исходники админки — **ES-модули**; при `asset_source :sprockets` Sprockets отдаёт их по отдельности, и в браузере возникают ошибки `import`/`export` — не работают фильтры, **CKEditor** и т.д.

В проекте подключён **собранный IIFE-бандл** (`vendor/assets/javascripts/rails_admin_application_bundle.js`). После обновления гема `rails_admin` пересоберите:

```bash
npm install
npm run build:rails_admin
```

**Docker:** каталог `node_modules` в образе не монтируется с хоста (отдельный volume `app_node_modules`), иначе на Linux в контейнере попадёт бинарник **esbuild** с macOS → `Exec format error`. Один раз в контейнере:

```bash
docker compose exec app npm install
docker compose exec app npm run build:rails_admin
```

Собранный `vendor/...` попадёт в примонтированный проект на хосте.

## Быстрый запуск (Docker)

1. Скопируйте пример переменных окружения:
   ```bash
   cp .env.local.example .env.local
   ```

2. Запустите приложение и MySQL:
   ```bash
   docker compose up --build
   ```

3. Откройте в браузере: **http://localhost:3000**

### Что делает контейнер при старте

- Ожидает готовности MySQL
- При необходимости копирует `config/database.yml.example` → `config/database.yml`
- Проверяет/устанавливает gem-зависимости (`bundle install`)
- Выполняет `rails db:prepare` (создание БД и миграции при первом запуске)
- Запускает `rails server`

### Импорт старого дампа MySQL

Скрипт **`bin/import_mysql_dump`** подхватывает **`.env.local`**.

**MySQL в Docker, дамп на хосте** (основной вариант): поток с диска хоста идёт в `mysql` внутри контейнера БД, путь к файлу — любой на вашей машине.

```bash
# из корня репозитория, контейнер db должен быть запущен (docker compose up -d)
bin/import_mysql_dump --docker ~/Downloads/legacy.sql
bin/import_mysql_dump --docker ./tmp/archive.sql.gz
bin/import_mysql_dump --docker --recreate ./dump.sql   # пересоздать БД DB_NAME, затем импорт
```

Пароль root берётся из **`MYSQL_ROOT_PASSWORD`**. Чтобы не писать `--docker` каждый раз, в `.env.local` можно задать **`MYSQL_DUMP_VIA_DOCKER=1`**.

**Без Docker** (клиент `mysql` на хосте, сервер на `127.0.0.1` и т.д.): `DB_HOST=127.0.0.1 bin/import_mysql_dump ./dump.sql` — те же **`DB_*`**, что в `database.yml`.

## Переменные окружения

Подставляются из `.env.local` через `env_file` в `docker-compose.yml`.

| Переменная | Описание |
|------------|----------|
| `APP_URL` | Канонический URL сайта (`http://localhost:3000` в dev, `https://…` в prod). RSS, Disqus, `post#link`, Google Analytics (домен из хоста). Без `/` в конце |
| `DB_HOST` | Хост MySQL (в Docker: `db`) |
| `DB_USERNAME` | Пользователь БД |
| `DB_PASSWORD` | Пароль БД |
| `DB_NAME` | Имя БД для development |
| `DB_TEST_NAME` | Имя БД для test |
| `SECRET_KEY_BASE` | Секрет Rails (обязателен в production) |
| `MYSQL_ROOT_PASSWORD` | Пароль root для контейнера MySQL |
| `MYSQL_DATABASE` | База по умолчанию в MySQL |
| `RAILS_LOG_TO_STDOUT` | `true` — логи в STDOUT (видны в `docker compose logs`); иначе только `log/development.log` |
| `LOG_LEVEL` | `debug` (по умолчанию в development), `info` в production — детализация логов |

### MySQL в Docker и безопасность

| Окружение | Что уже сделано / на что обратить внимание |
|-----------|---------------------------------------------|
| **Production** (`docker-compose.production.yml`) | Порт **3306 не публикуется** наружу — MySQL доступен только контейнерам в той же сети Compose. Обязательные **`MYSQL_ROOT_PASSWORD`** и **`DB_PASSWORD`**, приложение ходит под **`MYSQL_USER`**, не под root. |
| **Development** (`docker-compose.yml`) | Проброс порта привязан к **`127.0.0.1:3306`**, чтобы не слушать на всех интерфейсах хоста. Пароли в `.env.local.example` — **только для локальной разработки**; для общего ПК/сети задайте свои. Сейчас приложение может подключаться как **`root`** — для dev это упрощает жизнь; в production используйте отдельного пользователя (как в production compose). |

Образ **`mysql:8.4`** — официальный; при заданном `MYSQL_ROOT_PASSWORD` пустой root-пароль не используется. Дополнительно: не коммить `.env.local` / `.env.production`, не открывать порт MySQL в проде наружу без необходимости.

### Логи

- **Docker:** в `docker-compose.yml` для `app` задано `RAILS_LOG_TO_STDOUT=true`, логи Rails и SQL смотри так:
  ```bash
  docker compose logs -f app
  ```
- **Без Docker:** смотри файл `log/development.log` или запускай сервер в терминале — вывод пойдёт в консоль.
- Уровень детализации: переменная **`LOG_LEVEL`** (`debug`, `info`, `warn`, …). В development по умолчанию **`debug`** (включая подробный SQL с указанием места в коде — `verbose_query_logs`).

## Запуск без Docker

1. Создайте БД MySQL и настройте `config/database.yml` (можно от `config/database.yml.example`).
2. Установите зависимости и подготовьте БД:
   ```bash
   bundle install
   rails db:prepare
   ```
3. Запустите сервер:
   ```bash
   rails server
   ```

## Деплой (Docker) — рекомендуемый вариант

Деплой = сборка **образа** и запуск **Compose** (или оркестратор) на сервере. Типичный поток:

1. **CI** (GitHub Actions, GitLab CI, …): `docker build --target production` → push в registry (GHCR, Docker Hub, свой).
2. **Сервер**: `docker compose pull` → `docker compose up -d` (или аналог с секретами и `RAILS_ENV=production`).

### Multi-stage `Dockerfile`

- **`target: development`** — локальная разработка (`docker compose up`): как раньше, монтирование кода, `rails server`, `entrypoint.sh` с `db:prepare`.
- **`target: production`** — отдельный runtime-образ: в стадии **builder** выполняются `npm ci`, `npm run build:rails_admin`, `RAILS_ENV=production bundle exec rails assets:precompile`; в финальном образе нет исходников с хоста, статика и дайджесты уже внутри image. Запуск: **Puma** с `config/puma/docker.rb` (HTTP), `docker/entrypoint.production.sh` (ожидание MySQL, опционально `db:migrate`).

Сборка production-образа вручную:

```bash
docker build --target production -t zxevo:production .
```

### Пример production Compose

Файл **`docker-compose.production.yml`**: БД + app без bind-mount кода, volume для **`public/uploads`**, переменные из `.env.production`.

```bash
cp .env.production.example .env.production
# задать SECRET_KEY_BASE, пароли и т.д.

docker compose -f docker-compose.production.yml --env-file .env.production up -d --build
```

Пользователь БД приложения по умолчанию совпадает с `MYSQL_USER` в образе MySQL (`DB_USERNAME`, по умолчанию `zxevo`). Для внешней БД уберите сервис `db` и задайте `DB_HOST` / учётные данные в env.

## Основные маршруты

| Путь | Назначение |
|------|------------|
| `/` | Главная |
| `/blog` | Список постов |
| `/rss` | RSS-лента |
| `/admin` | Админ-панель (Rails Admin) |
| `/login`, `/logout`, `/signup` | Devise |
| `/:slug` | Статическая страница по slug |

## Стек

- Ruby 3.3.4, Rails 6.1
- MySQL 8, Devise, Rails Admin, CKEditor
- Slim, Bootstrap 3, SASS, CarrierWave
