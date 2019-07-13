#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

${current}/package.sh ${TRAVIS_BUILD_DIR}/gh-pages/gutenberg

bash ${current}/commit.sh
