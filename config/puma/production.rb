require 'pathname'

daemonize
app_root = Pathname.new('../../..').expand_path(__FILE__)
tmp_dir  = app_root.join('tmp')
pids_dir = tmp_dir.join('pids')
logs_dir = app_root.join('log')

environment 'production'

pidfile     pids_dir.join('puma.pid').to_s
state_path  tmp_dir.join('puma.state').to_s

bind 'unix:/home/foxweb/www/zx.rediron.ru/shared/sockets/puma.sock'

# production_log_path = logs_dir.join('production.log').to_s
# stdout_redirect production_log_path, production_log_path, true
