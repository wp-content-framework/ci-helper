#!/usr/bin/env bash

set -e

if [[ -z $(composer list --raw --working-dir=${TRAVIS_BUILD_DIR} | grep phpunit) ]]; then
    echo "composer phpunit command is invalid."
    exit
fi

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/..; pwd -P)
bash ${SCRIPT_DIR}/php/setup-wp-tests.sh
ls -la ${TRAVIS_BUILD_DIR}/vendor/autoload.php

echo ""
echo ">> Run composer phpunit."
composer phpunit --working-dir=${TRAVIS_BUILD_DIR}

if [[ ! -z "${COVERAGE_REPORT}" ]] && [[ ! -z "${CI}" ]]; then
    if [[ -z $(composer list --raw --working-dir=${TRAVIS_BUILD_DIR} | grep coveralls) ]]; then
        echo "composer coveralls command is invalid."
        exit
    fi
	ls -la ${TRAVIS_BUILD_DIR}/coverage/clover.xml
	echo ""
	echo ">> Run composer coveralls."
	composer coveralls --working-dir=${TRAVIS_BUILD_DIR}
fi
