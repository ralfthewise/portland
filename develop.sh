#!/bin/bash

ROOT="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "${ROOT}" > /dev/null
docker build --rm -t portland "$ROOT/docker/development"
#docker run --rm -t -i -u `id -u` -v /var/run/docker.sock:/var/run/docker.sock -p 3000:3000 -p 3001:3001 -v "$ROOT":/app -w /app portland "$@"
docker run --rm -t -i -v /var/run/docker.sock:/var/run/docker.sock -p 8000:80 -v "$ROOT":/app -w /app --name=portland portland "$@"
docker rm $(docker ps -a -q) 2> /dev/null
#docker rmi $(docker images -q --filter "dangling=true") 2> /dev/null
popd > /dev/null
