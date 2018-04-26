require File.expand_path('boot', __dir__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Zxevo
  class Application < Rails::Application
    config.time_zone = 'Moscow'
    config.i18n.default_locale = :ru
  end
end
