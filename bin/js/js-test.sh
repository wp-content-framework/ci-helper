#!/usr/bin/env bash

set -e

if [[ ! -f ${TRAVIS_BUILD_DIR}/assets/js/package.json ]]; then
    echo "package.json is required. "
    exit
fi

if [[ -z $(npm run --prefix ${TRAVIS_BUILD_DIR}/assets/js | grep cover) ]]; then
	echo "npm cover command is invalid."
	exit
fi

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/..; pwd -P)
bash ${SCRIPT_DIR}/js/install-npm.sh
ls -la ${TRAVIS_BUILD_DIR}/assets/js/node_modules/.bin/webpack

echo ""
echo ">> Run npm test."
npm run cover --prefix ${TRAVIS_BUILD_DIR}/assets/js

if [[ ! -z "${COVERAGE_REPORT}" ]] && [[ ! -z "${CI}" ]]; then
	ls -la ${TRAVIS_BUILD_DIR}/assets/js/coverage/lcov.info
	echo ""
	echo ">> Run npm coveralls."
	npm run coveralls --prefix ${TRAVIS_BUILD_DIR}/assets/js
fi
