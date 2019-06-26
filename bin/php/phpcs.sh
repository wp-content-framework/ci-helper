#!/usr/bin/env bash

set -e

if [[ -z $(composer list --raw --working-dir=${TRAVIS_BUILD_DIR} | grep phpcs) ]]; then
    echo "composer phpcs command is invalid."
    exit
fi

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/..; pwd -P)
bash ${SCRIPT_DIR}/php/install-composer.sh
ls -la ${TRAVIS_BUILD_DIR}/vendor/autoload.php

echo ""
echo ">> Run composer phpcs."
composer phpcs --working-dir=${TRAVIS_BUILD_DIR}
