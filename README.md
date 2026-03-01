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

## Переменные окружения

Подставляются из `.env.local` через `env_file` в `docker-compose.yml`.

| Переменная | Описание |
|------------|----------|
| `DB_HOST` | Хост MySQL (в Docker: `db`) |
| `DB_USERNAME` | Пользователь БД |
| `DB_PASSWORD` | Пароль БД |
| `DB_NAME` | Имя БД для development |
| `DB_TEST_NAME` | Имя БД для test |
| `SECRET_KEY_BASE` | Секрет Rails (обязателен в production) |
| `MYSQL_ROOT_PASSWORD` | Пароль root для контейнера MySQL |
| `MYSQL_DATABASE` | База по умолчанию в MySQL |

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
