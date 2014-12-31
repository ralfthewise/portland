#!/bin/bash

bundle exec eye load eye/development.eye

#fancy status dashboard
tmux new-session -d "bash -l -c \"bundle exec eye watch\""
tmux split-window -h -p 65 "bash -c \"trap 'tmux kill-session' SIGINT SIGTERM; tail -f /tmp/eye.log /tmp/rails.log /app/log/development.log /tmp/terminal.log /var/log/nginx/error.log /var/log/nginx/access.log\""
tmux -2 attach-session

#or to just tail things
#tail -f /tmp/eye.log /tmp/rails.log /app/log/development.log /tmp/terminal.log /var/log/nginx/error.log /var/log/nginx/access.log

bundle exec eye quit -s
