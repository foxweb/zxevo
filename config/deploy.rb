require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '37.139.12.234'
set :user, 'foxweb'
set :deploy_to, '/home/foxweb/www/zxevo'
set :app_path, "#{deploy_to}/#{current_path}"

set :repository, 'git@github.com:foxweb/zxevo.git'
set :branch, 'master'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log', 'tmp']

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

desc 'Sets current deploy environment to production'
task :production do
  set :domain, '37.139.12.234'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]
  
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]
  
  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]
  
  queue! %[mkdir -p "#{deploy_to}/shared/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/sockets"]

  queue! %[mkdir -p "#{deploy_to}/shared/uploads"]
  queue! %[chmod g+rwx,u+rwx "#{deploy_to}/shared/uploads"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    
    to :launch do
      queue! %[ln -nfs #{deploy_to}/shared/db/production.sqlite3 #{deploy_to}/#{current_path}/db/production.sqlite3]
      queue! %[rm -rf #{deploy_to}/#{current_path}/public/uploads]
      queue! %[ln -nfs #{deploy_to}/shared/uploads #{deploy_to}/#{current_path}/public/uploads]
      queue! 'bundle exec bluepill --no-privileged dev stop'
      queue! 'bundle exec bluepill --no-privileged dev start'
    end
  end
end

namespace :logs do
  desc 'tail -f log/production.log'
  task :tail do
    queue "tail -f #{app_path}/log/production.log"
  end
  
  desc 'less log/production.log'
  task :less do
    queue "less #{app_path}/log/production.log"
  end
end
