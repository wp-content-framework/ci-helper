#!/usr/bin/env bash

set -e

INSTALL=${1-""}
if [[ -n "${TRAVIS_BUILD_STAGE_NAME}" ]] && [[ ! "${TRAVIS_BUILD_STAGE_NAME}" =~ ^Test ]]; then
    INSTALL=""
fi
if [[ -n "${ACTIVATE_POPULAR_PLUGINS}" ]] || [[ -n "${INSTALL}" ]]; then
    echo "TRUE"
fi
