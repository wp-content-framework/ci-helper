#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

if [[ -z $(composer list --raw --working-dir=${TRAVIS_BUILD_DIR} | grep phpmd) ]]; then
    echo "composer phpmd command is invalid."
    exit
fi

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/..; pwd -P)
bash ${SCRIPT_DIR}/php/install-composer.sh
ls -la ${TRAVIS_BUILD_DIR}/vendor/autoload.php

echo ""
echo ">> Run composer phpmd."
composer phpmd --working-dir=${TRAVIS_BUILD_DIR}
