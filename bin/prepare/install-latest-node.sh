#!/usr/bin/env bash

set -e

#NODE_JS_VERSION=${NODE_JS_VERSION:-node}
NODE_JS_VERSION=${NODE_JS_VERSION:-11}

if [[ ! -d ~/.nvm/.git ]]; then
    rm -rf ~/.nvm
    git clone https://github.com/creationix/nvm.git ~/.nvm
fi
git -C ~/.nvm checkout $(git -C ~/.nvm describe --abbrev=0 --tags)

source ~/.nvm/nvm.sh && nvm install ${NODE_JS_VERSION} && nvm alias default ${NODE_JS_VERSION}
node --version
