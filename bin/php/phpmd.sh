#!/usr/bin/env bash

set -e

current=$(
  cd $(dirname $0)
  pwd
)
source ${current}/../variables.sh

if [[ -z $(composer list --raw --working-dir=${TRAVIS_BUILD_DIR} | grep phpmd) ]]; then
  echo "composer phpmd command is invalid."
  exit
fi

bash ${SCRIPT_DIR}/php/install-composer.sh
ls -la ${TRAVIS_BUILD_DIR}/vendor/autoload.php

targets="./src/"
if [[ -d "${TRAVIS_BUILD_DIR}/configs" ]]; then
  targets="${targets},./configs/"
fi
if [[ -d "${TRAVIS_BUILD_DIR}/tests" ]]; then
  targets="${targets},./tests/"
fi

exclude=""
if [[ -d "${TRAVIS_BUILD_DIR}/src/views" ]]; then
  exclude="--exclude ./src/views/*"
fi

echo ""
echo ">> Run composer phpmd."
if [[ -n "${GIT_DIFF}" ]]; then
  "${TRAVIS_BUILD_DIR}"/vendor/bin/phpmd "$(eval echo "${GIT_DIFF}")" "${targets}" ansi "${TRAVIS_BUILD_DIR}/phpmd.xml" "${exclude}"
else
  "${TRAVIS_BUILD_DIR}"/vendor/bin/phpmd "${targets}" ansi "${TRAVIS_BUILD_DIR}/phpmd.xml" "${exclude}"
fi
