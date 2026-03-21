# frozen_string_literal: true

# Опционально: деплой на «голый» VPS по SSH (git + bundle + Puma).
# Если прод только через Docker — этот файл не нужен, см. README «Деплой (Docker)».
#
# Mina 1.x — см. https://github.com/mina-deploy/mina/blob/master/docs/migrating.md
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :domain, '37.139.12.234'
set :user, 'foxweb'
# Каталог на сервере (override: export MINA_DEPLOY_TO=/path/to/app)
set :deploy_to, ENV.fetch('MINA_DEPLOY_TO', '/var/www/zxevo')
set :repository, 'git@github.com:foxweb/zxevo.git'
set :branch, `git rev-parse --abbrev-ref HEAD`.strip
set :keep_releases, 5

# Было shared_paths (Mina 0.x) — разделение на каталоги и файлы
set :shared_files, fetch(:shared_files, []).push('config/database.yml')
set :shared_dirs, fetch(:shared_dirs, []).push('public/uploads', 'tmp/pids')

# На сервере нужны Node.js + npm (например 20.x) для сборки RailsAdmin JS
# (vendor/assets/javascripts/rails_admin_application_bundle.js).

task :remote_environment do
  invoke :'rbenv:load'
end

desc 'Выкладка в production (ветка master)'
task :production do
  set :branch, 'master'
end

desc 'Первичная настройка каталогов на сервере (после mina setup)'
task :'server:setup' do
  invoke :'rbenv:load'
  command %(mkdir -p "#{fetch(:deploy_to)}/shared/public/assets")
  command %(chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/public/assets")
  command %(mkdir -p "#{fetch(:deploy_to)}/shared/config")
  command %(chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/config")
  command %(touch "#{fetch(:deploy_to)}/shared/config/database.yml")
  command %(mkdir -p "#{fetch(:deploy_to)}/shared/sockets")
  command %(chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/sockets")
  command %(mkdir -p "#{fetch(:deploy_to)}/shared/public/uploads")
  command %(chmod g+rwx,u+rwx "#{fetch(:deploy_to)}/shared/public/uploads")
  command %(mkdir -p "#{fetch(:deploy_to)}/shared/log")
  command %(chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/log")
  command %(mkdir -p "#{fetch(:deploy_to)}/shared/tmp/pids")
  command %(chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp/pids")
end

namespace :npm do
  desc 'npm ci + сборка бандла RailsAdmin (esbuild, см. package.json)'
  task :build do
    ensure!(:deploy_block, message: 'Запускайте только внутри deploy do … end')
    comment %(npm ci и npm run build:rails_admin)
    command %(
      if ! command -v npm >/dev/null 2>&1; then
        echo "! Установите Node.js/npm на сервере (рекомендуется LTS)"
        exit 1
      fi
      export NODE_ENV=production
      npm ci &&
      npm run build:rails_admin
    )
  end
end

desc 'Deploys the current version to the server.'
task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'npm:build'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'puma:restart'
    end
  end
end

namespace :logs do
  desc 'tail -f log/production.log'
  task :tail do
    set :execution_mode, :exec
    in_path fetch(:current_path) do
      command %(tail -f log/production.log)
    end
  end

  desc 'less log/production.log'
  task :less do
    set :execution_mode, :exec
    in_path fetch(:current_path) do
      command %(less log/production.log)
    end
  end
end

namespace :puma do
  desc 'Restart puma'
  task restart: :remote_environment do
    command %(
      cd #{fetch(:current_path)} && bundle exec pumactl -F ./config/puma/production.rb restart
    )
  end

  desc 'Stop puma'
  task stop: :remote_environment do
    command %(
      cd #{fetch(:current_path)} && bundle exec pumactl -S ./tmp/puma.state stop
    )
  end

  desc 'Start puma'
  task start: :remote_environment do
    command %(
      cd #{fetch(:current_path)} && bundle exec puma -C ./config/puma/production.rb
    )
  end
end
