#!/usr/bin/env bash

set -e

if [[ -z "${TRAVIS_BUILD_DIR}" ]]; then
    echo "<TRAVIS_BUILD_DIR> is required"
    exit
fi

SETTINGS_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/../settings; pwd -P)

files=()
files+=( ".coveralls.yml" )
files+=( "phpcs.xml" )
files+=( "phpmd.xml" )
files+=( "phpunit.xml" )

for file in "${files[@]}"
do
    if [[ ! -f ${TRAVIS_BUILD_DIR}/${file} ]]; then
        cp ${SETTINGS_DIR}/${file} ${TRAVIS_BUILD_DIR}/${file}
    fi
done
