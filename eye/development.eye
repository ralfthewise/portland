# -*- mode: ruby -*-
# vi: set ft=ruby :

app_root = File.expand_path(File.join('..', '..'), __FILE__)
Eye.config do
  logger '/tmp/eye.log'
end

Eye.application 'portland' do
  working_dir(app_root)

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

  process :terminal do
    pid_file '/tmp/terminal.pid'
    stdall('/tmp/terminal.log')
    daemonize true
    start_command './terminal/run.sh'
    stop_signals [:INT, 15.seconds, :KILL]
    trigger :stop_children, :event => [:stopped, :crashed]
    monitor_children do
      stop_signals [:INT, 15.seconds, :KILL]
    end
  end

  process :docker_api do
    pid_file '/tmp/docker_api.pid'
    daemonize true
    #start_command 'socat TCP-LISTEN:3001,bind=127.0.0.1,reuseaddr,fork,range=127.0.0.0/8 UNIX-CLIENT:/var/run/docker.sock'
    start_command 'socat TCP-LISTEN:3001,reuseaddr,fork UNIX-CLIENT:/var/run/docker.sock'
  end
end
