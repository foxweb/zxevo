#!/usr/bin/env bash
set -euo pipefail

cd /app

if [ ! -f config/database.yml ] && [ -f config/database.yml.example ]; then
  cp config/database.yml.example config/database.yml
fi

rm -f tmp/pids/server.pid

if [ -n "${DB_HOST:-}" ]; then
  echo "Waiting for MySQL at ${DB_HOST}:${DB_PORT:-3306}..."
  until mysqladmin ping -h"${DB_HOST}" -P"${DB_PORT:-3306}" -u"${DB_USERNAME:-root}" -p"${DB_PASSWORD:-}" --silent; do
    sleep 2
  done
fi

bundle _2.5.13_ check || bundle _2.5.13_ install
bundle _2.5.13_ exec rails db:prepare

exec "$@"
