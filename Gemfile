source 'https://rubygems.org'

ruby '3.3.4'

gem 'rails', '~> 6.1.7', '>= 6.1.7.10'

# >= 3.1.12: совместимость с libxcrypt (Docker/Ubuntu); иначе Password.create → InvalidHash
gem 'bcrypt', '~> 3.1', '>= 3.1.20'
gem 'carrierwave', '~> 3.1'
gem 'ckeditor', '~> 5.1'
gem 'devise', '~> 4.9'
gem 'font-awesome-rails'
# Default gem в Ruby 3.3+ — зафиксировать в bundle, иначе конфликт «already activated logger 1.7.0» с lockfile на 1.6.x
gem 'logger', '>= 1.6.0'
gem 'mini_magick', '~> 5.1'
gem 'mysql2', '~> 0.5.6'
gem 'puma', '~> 6.4'
gem 'rails_admin', '~> 3.3'
gem 'rails-i18n', '~> 7.0', '>= 7.0.1'
gem 'slim-rails', '~> 3.7'
# Sprockets 4 требует app/assets/config/manifest.js; на 3.x остаётся текущая схема ассетов
gem 'sprockets', '~> 4.2', '>= 4.2.0'
gem 'sprockets-rails', '~> 3.0', '>= 3.0.0'
gem 'turbolinks', '~> 5.2'

# bootstrap and css stuff
gem 'bootstrap-sass', '~> 3.4.1'
gem 'execjs'
gem 'jquery-rails', '~> 4.6'
gem 'sassc-rails'
gem 'terser', '~> 1.2'

group :development do
  gem 'better_errors', '~> 2.10'
end
