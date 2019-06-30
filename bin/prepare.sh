#!/usr/bin/env bash

set -e

if [[ -z "${TRAVIS_BUILD_DIR}" ]]; then
    echo "<TRAVIS_BUILD_DIR> is required"
    exit
fi

LIBRARY_BASE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/..; pwd -P)
SETTINGS_DIR=${LIBRARY_BASE_DIR}/settings
TESTS_DIR=${LIBRARY_BASE_DIR}/tests
SCRIPT_DIR=${LIBRARY_BASE_DIR}/bin

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

files=()
files+=( "bootstrap.php" )
if [[ -d ${TRAVIS_BUILD_DIR}/tests ]]; then
    for file in "${files[@]}"
    do
        if [[ ! -f ${TRAVIS_BUILD_DIR}/tests/${file} ]]; then
            cp ${TESTS_DIR}/${file} ${TRAVIS_BUILD_DIR}/tests/${file}
        fi
    done
fi

if [[ -n "${ACTIVATE_POPULAR_PLUGINS}" ]]; then
    rm -rdf ${TESTS_DIR}/.plugin
    bash ${SCRIPT_DIR}/plugins.sh

    for plugin in "${org_plugins[@]}"
    do
        bash ${SCRIPT_DIR}/install-org-plugin.sh ${plugin}
    done

    for plugin in "${github_plugins[@]}"
    do
        bash ${SCRIPT_DIR}/install-github-plugin.sh ${plugin}
    done
fi
