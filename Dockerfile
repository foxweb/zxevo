# syntax=docker/dockerfile:1
# Локальная разработка: target development (как раньше).
# Production: target production — multi-stage, ассеты и npm-сборка в образе.

ARG RUBY_VERSION=3.3.4

# -----------------------------------------------------------------------------
# Development — монтирование кода с хоста, без предсборки ассетов в образе
# -----------------------------------------------------------------------------
FROM ruby:${RUBY_VERSION}-slim AS development

ENV APP_HOME=/app \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

WORKDIR $APP_HOME

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  default-libmysqlclient-dev \
  default-mysql-client \
  pkg-config \
  nodejs \
  npm \
  git \
  curl \
  tzdata \
  imagemagick \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.5.13 && bundle _2.5.13_ install

COPY . .

COPY docker/entrypoint.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/entrypoint

EXPOSE 3000
ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]

# -----------------------------------------------------------------------------
# Builder — gems, npm, бандл RailsAdmin, assets:precompile
# -----------------------------------------------------------------------------
FROM ruby:${RUBY_VERSION}-slim AS builder

ENV APP_HOME=/app \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_WITHOUT="development:test" \
    RAILS_ENV=production

WORKDIR $APP_HOME

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  default-libmysqlclient-dev \
  default-mysql-client \
  pkg-config \
  nodejs \
  npm \
  git \
  curl \
  tzdata \
  imagemagick \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.5.13 && bundle _2.5.13_ install --without development test --deployment

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

RUN npm run build:rails_admin

# SECRET_KEY_BASE только на время precompile (не хранить в слоях образа как постоянный ENV)
RUN SECRET_KEY_BASE=precompile_dummy_not_for_runtime bundle exec rails assets:precompile \
  && rm -rf node_modules tmp/cache

# -----------------------------------------------------------------------------
# Production — без компиляторов, только runtime
# -----------------------------------------------------------------------------
FROM ruby:${RUBY_VERSION}-slim AS production

ENV APP_HOME=/app \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_WITHOUT="development:test" \
    RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true

WORKDIR $APP_HOME

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  default-libmysqlclient-dev \
  default-mysql-client \
  curl \
  tzdata \
  imagemagick \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

COPY docker/entrypoint.production.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/entrypoint

RUN mkdir -p tmp/pids log

EXPOSE 3000
ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["bundle", "exec", "puma", "-C", "config/puma/docker.rb"]
