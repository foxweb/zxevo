#!/usr/bin/env bash
set -euo pipefail

cd /app

if [ ! -f config/database.yml ] && [ -f config/database.yml.example ]; then
  cp config/database.yml.example config/database.yml
fi

rm -f tmp/pids/server.pid tmp/pids/puma.pid

if [ -n "${DB_HOST:-}" ]; then
  echo "Waiting for MySQL at ${DB_HOST}:${DB_PORT:-3306}..."
  until mysqladmin ping -h"${DB_HOST}" -P"${DB_PORT:-3306}" -u"${DB_USERNAME:-root}" -p"${DB_PASSWORD:-}" --silent 2>/dev/null; do
    sleep 2
  done
  echo "MySQL is up."
fi

# Миграции при старте (для простых деплоев). При желании вынесите в CI: закомментируйте строку ниже.
if [ "${RUN_DB_MIGRATE_ON_START:-true}" = "true" ]; then
  bundle exec rails db:migrate
fi

exec "$@"
