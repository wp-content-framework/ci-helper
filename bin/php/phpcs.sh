#!/usr/bin/env bash

set -e

current=$(
  cd $(dirname $0)
  pwd
)
source ${current}/../variables.sh

if [[ -z $(composer list --raw --working-dir=${TRAVIS_BUILD_DIR} | grep phpcs) ]]; then
  echo "composer phpcs command is invalid."
  exit
fi

bash ${SCRIPT_DIR}/php/install-composer.sh
ls -la ${TRAVIS_BUILD_DIR}/vendor/autoload.php

echo ""
echo ">> Run composer phpcs."
if [[ -n "${GIT_DIFF}" ]]; then
  # shellcheck disable=SC2046
  "${TRAVIS_BUILD_DIR}"/vendor/bin/phpcs --standard="${TRAVIS_BUILD_DIR}/phpcs.xml" $(eval echo "${GIT_DIFF}")
else
  "${TRAVIS_BUILD_DIR}"/vendor/bin/phpcs --standard="${TRAVIS_BUILD_DIR}/phpcs.xml"
fi
