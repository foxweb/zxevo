# frozen_string_literal: true

# Маршруты и письма с полными URL (post_url, rss_url и т.д.) используют хост из APP_URL.
Rails.application.config.after_initialize do
  app_url = Rails.application.config.x.app_url
  uri = URI.parse(app_url)
  opts = { host: uri.host, protocol: uri.scheme }
  opts[:port] = uri.port unless [80, 443].include?(uri.port)

  Rails.application.routes.default_url_options.merge!(opts)
  mailer_opts = Rails.application.config.action_mailer.default_url_options || {}
  Rails.application.config.action_mailer.default_url_options = mailer_opts.merge(opts)
end
