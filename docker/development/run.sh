#!/bin/bash

bundle install --path vendor/bundle --binstubs vendor/bundle/bin --without production
bundle exec eye load eye/development.eye

LOG_FILES=(
  /var/log/nginx/error.log
  /var/log/nginx/access.log
  /var/log/redis/redis-server.log
  /tmp/eye.log
  /tmp/rails.log
  /tmp/ws_server.log
  /tmp/docker_stream_events.log
  /tmp/terminal.log
  /app/log/development.log
  /app/log/websocket_rails.log
  /app/log/websocket_rails_server.log
)

if [ -t 1 ]; then
  #we're attached to a terminal, do our fancy dashboard
  tmux new-session -d "bash -l -c \"bundle exec eye watch\""
  tmux split-window -h -p 65 "bash -c \"trap 'tmux kill-session' SIGINT SIGTERM; tail -f ${LOG_FILES[*]}\""
  tmux -2 attach-session
else
  #we're not attached to a terminal, just do simple logging
  tail -f ${LOG_FILES[*]}
fi

echo "Shutting down..."
bundle exec eye quit -s
