#!/usr/bin/env bash

set -e

if [[ $# -lt 1 ]]; then
	echo "usage: $0 <github repo>"
	exit 1
fi

GITHUB_REPO=$1
PLUGIN_SLUG=${GITHUB_REPO##*/}

git clone --depth=1 https://github.com/${GITHUB_REPO}.git ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}

if [[ -f ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}/composer.json ]]; then
    composer install -n --working-dir=${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG} --no-dev
fi
if [[ -f ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}/package.json ]]; then
    npm install --prefix ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG} --save-dev
    npm run build --prefix ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}
fi
if [[ -f ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}/assets/js/package.json ]]; then
    npm install --prefix ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}/assets/js --save-dev
    npm run build --prefix ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}/assets/js
fi
