#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

echo ""
echo ">> Run yarn install."
yarn --cwd ${TRAVIS_BUILD_DIR}/assets/js install
