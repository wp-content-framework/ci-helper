#!/usr/bin/env bash

set -e

if [[ $# -lt 1 ]]; then
	echo "usage: $0 <github repo>"
	exit 1
fi

TESTS_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/../../tests; pwd -P)
GITHUB_REPO=$1
PLUGIN_SLUG=${GITHUB_REPO##*/}

git clone --depth=1 https://github.com/${GITHUB_REPO}.git ${TESTS_DIR}/.plugin/${PLUGIN_SLUG}

if [[ -f ${TESTS_DIR}/.plugin/${PLUGIN_SLUG}/composer.json ]]; then
    composer install -n --working-dir=${TESTS_DIR}/.plugin/${PLUGIN_SLUG} --no-dev
fi
if [[ -f ${TESTS_DIR}/.plugin/${PLUGIN_SLUG}/package.json ]]; then
    npm install --prefix ${TESTS_DIR}/.plugin/${PLUGIN_SLUG} --save-dev
    npm run build --prefix ${TESTS_DIR}/.plugin/${PLUGIN_SLUG}
fi
if [[ -f ${TESTS_DIR}/.plugin/${PLUGIN_SLUG}/assets/js/package.json ]]; then
    npm install --prefix ${TESTS_DIR}/.plugin/${PLUGIN_SLUG}/assets/js --save-dev
    npm run build --prefix ${TESTS_DIR}/.plugin/${PLUGIN_SLUG}/assets/js
fi
