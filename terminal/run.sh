#!/bin/bash

ROOT="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${ROOT}"
npm install
exec node index.js
