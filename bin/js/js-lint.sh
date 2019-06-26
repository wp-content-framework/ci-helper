#!/usr/bin/env bash

set -e

if [[ ! -f ${TRAVIS_BUILD_DIR}/assets/js/package.json ]]; then
    echo "package.json is required. "
    exit
fi

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/..; pwd -P)
bash ${SCRIPT_DIR}/js/install-npm.sh
ls -la ${TRAVIS_BUILD_DIR}/assets/js/node_modules/.bin/webpack

echo ""
echo ">> Run npm lint."
npm run lint --prefix ${TRAVIS_BUILD_DIR}/assets/js
