# encoding: utf-8

require 'bundler/capistrano'
require 'puma/capistrano'
require 'capistrano-rbenv'
set :rbenv_ruby_version, '2.0.0-p195'

default_run_options[:pty] = true

set :application, 'zxevo'

set :user, 'foxweb'
set :use_sudo, false
set :deploy_to, "/home/foxweb/www/#{application}"
set :deploy_via, :remote_cache
set :shared_children, shared_children << 'tmp/sockets'
set :stage, 'production'

role :web, 'rediron.ru'
role :app, 'rediron.ru'
role :db,  'rediron.ru', primary: true

set :scm, :git
set :repository,  'git@github.com:foxweb/zxevo.git'
set :git_enable_submodules, 1
set :branch, 'master'

ssh_options[:forward_agent] = true

namespace :deploy do
  task :bundle_gems do
    run "cd #{deploy_to}/current && bundle install --deployment"
  end

  task :finalize_update do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/settings.local.yml #{release_path}/config/settings.local.yml"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/tmp #{release_path}/tmp"
    run "ln -nfs #{shared_path}/log #{release_path}/log"
    run "ln -nfs #{shared_path}/tmp/sockets #{release_path}/tmp/sockets"
    run "ln -nfs #{shared_path}/db #{release_path}/db/sqlite"
  end

  task :precompile_assets do
    run "cd #{release_path}; bundle exec rake assets:precompile RAILS_ENV=production"
  end

  desc "Start the application"
  task :start, roles: :app, except: { no_release: true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec puma -b 'unix://#{shared_path}/sockets/puma.sock' -S #{shared_path}/sockets/puma.state --control 'unix://#{shared_path}/sockets/pumactl.sock' >> #{shared_path}/log/puma-#{stage}.log 2>&1 &", :pty => false
  end
 
  desc "Stop the application"
  task :stop, roles: :app, except: { no_release: true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state stop"
  end
 
  desc "Restart the application"
  task :restart, roles: :app, except: { no_release: true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state restart"
  end
 
  desc "Status of the application"
  task :status, roles: :app, except: { no_release: true } do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec pumactl -S #{shared_path}/sockets/puma.state stats"
  end
end
