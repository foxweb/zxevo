require 'pathname'

app_root = Pathname.new('../../..').expand_path(__FILE__)
tmp_dir  = app_root.join('tmp')
pids_dir = tmp_dir.join('pids')
logs_dir = app_root.join('log')

pidfile     pids_dir.join('puma.pid').to_s
state_path  tmp_dir.join('puma.state').to_s

bind 'tcp://0.0.0.0:9393'

development_log_path = logs_dir.join('development.log').to_s
stdout_redirect development_log_path, development_log_path, true
