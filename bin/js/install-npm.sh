#!/usr/bin/env bash

set -e

echo ""
echo ">> Run yarn install."
yarn --cwd ${TRAVIS_BUILD_DIR}/assets/js install
