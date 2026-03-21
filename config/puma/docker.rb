# frozen_string_literal: true

# Puma в Docker (production): без daemonize, HTTP, без привязки к пути на старом VPS.
require 'pathname'

app_root = Pathname.new('../../..').expand_path(__FILE__)
tmp_dir  = app_root.join('tmp')
pids_dir = tmp_dir.join('pids')

environment 'production'

pidfile    pids_dir.join('puma.pid').to_s
state_path tmp_dir.join('puma.state').to_s

bind "tcp://0.0.0.0:#{ENV.fetch('PUMA_PORT', 3000)}"

threads Integer(ENV.fetch('RAILS_MAX_THREADS', 5)),
        Integer(ENV.fetch('RAILS_MAX_THREADS', 5))

# 0 — один процесс (только threads), экономия памяти в контейнере; >0 — cluster workers
wc = Integer(ENV.fetch('WEB_CONCURRENCY', '0'))
if wc.positive?
  workers wc
  preload_app!
end

# Логи — через Rails (RAILS_LOG_TO_STDOUT)
