#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

if [[ ! -f ${BIN_DIR}/packages.sh ]]; then
    echo ""
    echo "${BIN_DIR}/packages.sh is not exist"
    exit 1
fi

working_dir=${1-${TRAVIS_BUILD_DIR}}

if [[ ! -f ${working_dir}/composer.json ]]; then
    echo ""
    echo "${working_dir}/composer.json is not exist"
    exit 1
fi

packages=()
source ${BIN_DIR}/packages.sh

for package in "${packages[@]}"
do
    ${current}/composer/update.sh ${package} ${working_dir}
done

