#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

working_dir=${1-"${TRAVIS_BUILD_DIR}/assets/js"}

if [[ ! -f ${working_dir}/package.json ]]; then
    echo ""
    echo "${working_dir}/package.json is not exist"
    exit 1
fi

if [[ -z $(command -v ncu) ]]; then
    npm install -g npm-check-updates
fi
ncu -u --packageFile ${working_dir}/package.json
yarn --audit --cwd ${working_dir} install
