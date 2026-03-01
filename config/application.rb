require File.expand_path('boot', __dir__)

require 'logger'
require 'rails/all'

Bundler.require(*Rails.groups)

module Zxevo
  class Application < Rails::Application
    config.load_defaults 6.1
    config.time_zone = 'Moscow'
    config.i18n.default_locale = :ru
  end
end
