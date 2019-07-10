#!/usr/bin/env bash

set -e

echo ""
echo ">> Run yarn install."
yarn install --audit --prefix ${TRAVIS_BUILD_DIR}/assets/js
