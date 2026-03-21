Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # ---------- Логирование (подробно) ----------
  # :debug — всё, включая внутренности Rails; переопределение: LOG_LEVEL=info|warn|error
  log_level = ENV.fetch('LOG_LEVEL', 'debug').downcase.to_sym
  config.log_level = %i[debug info warn error fatal].include?(log_level) ? log_level : :debug
  # В логах SQL показывается, из какого места в коде ушёл запрос
  config.active_record.verbose_query_logs = true
  # request_id в каждой строке (удобно для трассировки запроса)
  config.log_tags = [:request_id]
  # В Docker без этого логи уходят в log/development.log, а `docker logs` остаётся пустым
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.level = {
      debug: Logger::DEBUG, info: Logger::INFO, warn: Logger::WARN,
      error: Logger::ERROR, fatal: Logger::FATAL
    }.fetch(config.log_level, Logger::DEBUG)
    logger.formatter = ::Logger::Formatter.new
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Rails 6.1: по умолчанию preload_links_header — Chrome в DevTools предупреждает
  # «preloaded but not used» для CSS (дубль Link rel=preload и <link rel="stylesheet">),
  # при assets.debug ещё и расхождение URL (?body=1). На работу страницы не влияет.
  config.action_view.preload_links_header = false

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
