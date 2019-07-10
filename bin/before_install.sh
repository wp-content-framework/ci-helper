#!/usr/bin/env bash

set -e

if [[ -z "${TRAVIS_BUILD_DIR}" ]]; then
    echo "<TRAVIS_BUILD_DIR> is required"
    exit
fi

LIBRARY_BASE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/..; pwd -P)
SCRIPT_DIR=${LIBRARY_BASE_DIR}/bin

if [[ -n "$(bash ${SCRIPT_DIR}/prepare/check-install.sh ${1-""})" ]]; then
    nvm install node
    nvm alias default node
fi
