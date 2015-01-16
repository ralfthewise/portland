#!/bin/bash

ROOT="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${ROOT}"

docker build --rm -t portland "$ROOT/docker/development"
#docker run --rm -it -u `id -u` -v /var/run/docker.sock:/var/run/docker.sock -p 3000:3000 -p 3001:3001 -v "$ROOT":/app -w /app portland "$@"
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -p 8000:80 -v "$ROOT":/app -w /app --name=portland portland "$@"
