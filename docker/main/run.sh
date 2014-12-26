#!/bin/bash

docker -d &
DOCKER_PID=$!
bash -l
echo 'Shutting down...'
kill $DOCKER_PID
sleep 1
