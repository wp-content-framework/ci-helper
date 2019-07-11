#!/usr/bin/env bash

set -e

#NODE_JS_VERSION=${NODE_JS_VERSION:-node}
NODE_JS_VERSION=${NODE_JS_VERSION:-11}

curl -o ~/.nvm/nvm.sh https://raw.githubusercontent.com/nvm-sh/nvm/master/nvm.sh
source ~/.nvm/nvm.sh && nvm install ${NODE_JS_VERSION} && nvm alias default ${NODE_JS_VERSION}
node --version
