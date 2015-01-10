# -*- mode: ruby -*-
# vi: set ft=ruby :

app_root = File.expand_path(File.join('..', '..'), __FILE__)
Eye.config do
  logger '/tmp/eye.log'
end

Eye.application 'portland' do
  working_dir(app_root)

  process :redis do
    pid_file '/var/run/redis/redis-server.pid'
    start_command 'redis-server /etc/redis/redis.conf'
  end

  process :nginx do
    pid_file '/tmp/nginx.pid'
    daemonize true
    start_command 'nginx -c /home/app/nginx.conf'
  end

  process :rails do
    pid_file '/tmp/rails.pid'
    stdall('/tmp/rails.log')
    daemonize true
    start_command 'bundle exec rails s'
    stop_signals [:INT, 15.seconds, :KILL]
  end

  process :ws_server do
    pid_file './tmp/pids/websocket_rails.pid'
    stdall('/tmp/ws_server.log')
    env({'REMOVE_RACK_LOCK' => 1})
    start_command 'bundle exec rake websocket_rails:start_server'
    stop_command 'bundle exec rake websocket_rails:stop_server'
  end

  process :docker_event_stream do
    pid_file '/tmp/docker_stream_events.pid'
    stdall('/tmp/docker_stream_events.log')
    daemonize true
    start_command 'bundle exec rake docker:stream_events'
    stop_signals [:INT, 15.seconds, :KILL]
  end

  process :terminal do
    pid_file '/tmp/terminal.pid'
    stdall('/tmp/terminal.log')
    daemonize true
    start_command './terminal/run.sh'
    stop_signals [:INT, 15.seconds, :KILL]
    trigger :stop_children, :event => [:stopped, :crashed]
    monitor_children
  end

  process :docker_api do
    pid_file '/tmp/docker_api.pid'
    daemonize true
    #start_command 'socat TCP-LISTEN:3002,bind=127.0.0.1,reuseaddr,fork,range=127.0.0.0/8 UNIX-CLIENT:/var/run/docker.sock'
    start_command 'socat TCP-LISTEN:3002,reuseaddr,fork UNIX-CLIENT:/var/run/docker.sock'
  end
end
