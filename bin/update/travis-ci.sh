#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

npm install -g npm-check-updates
ncu -u --packageFile ${TRAVIS_BUILD_DIR}/gh-pages/gutenberg/package.json
yarn --audit --cwd ${TRAVIS_BUILD_DIR}/gh-pages/gutenberg install
bash ${current}/commit.sh
