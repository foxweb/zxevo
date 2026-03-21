require File.expand_path('boot', __dir__)

require 'logger'
require 'rails/all'

Bundler.require(*Rails.groups)

module Zxevo
  class Application < Rails::Application
    config.load_defaults 6.1
    config.time_zone = 'Moscow'
    config.i18n.default_locale = :ru

    # Канонический URL сайта (без завершающего /). RSS, Disqus, абсолютные ссылки.
    config.x.app_url = ENV.fetch('APP_URL', 'http://localhost:3000').sub(%r{/\z}, '')
  end
end
