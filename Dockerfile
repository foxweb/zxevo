FROM ruby:3.3.4-slim

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
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.5.13 && bundle _2.5.13_ install

COPY . .

COPY docker/entrypoint.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/entrypoint

EXPOSE 3000
ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
