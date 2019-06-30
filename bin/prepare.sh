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

echo ""
echo ">> Copy files"
files=()
files+=( ".coveralls.yml" )
files+=( "phpcs.xml" )
files+=( "phpmd.xml" )
files+=( "phpunit.xml" )
for file in "${files[@]}"
do
    if [[ ! -f ${TRAVIS_BUILD_DIR}/${file} ]]; then
        echo ">>>> ${file}"
        cp ${SETTINGS_DIR}/${file} ${TRAVIS_BUILD_DIR}/${file}
    fi
done

files=()
files+=( "bootstrap.php" )
if [[ -d ${TRAVIS_BUILD_DIR}/tests ]]; then
    for file in "${files[@]}"
    do
        echo ">>>> tests/${file}"
        rm -f ${TRAVIS_BUILD_DIR}/tests/${file}
        cp ${TESTS_DIR}/${file} ${TRAVIS_BUILD_DIR}/tests/${file}
    done
fi

if [[ -n "${ACTIVATE_POPULAR_PLUGINS}" ]]; then
    echo ""
    echo ">> Download plugins"
    mkdir -p ${TRAVIS_BUILD_DIR}/.plugin
    source ${SCRIPT_DIR}/plugins.sh

    for plugin in "${org_plugins[@]}"
    do
        echo ">>>> ${plugin}"
        bash ${SCRIPT_DIR}/install-org-plugin.sh ${plugin}
    done

    if [[ ! -f ~/.ssh/config ]] || [[ -z $(cat ~/.ssh/config | grep github) ]]; then
        echo ">> Write to ssh config"
        echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
    fi
    for plugin in "${github_plugins[@]}"
    do
        echo ">>>> ${plugin}"
        bash ${SCRIPT_DIR}/install-github-plugin.sh ${plugin}
    done

    for plugin in "${zip_plugins[@]}"
    do
        echo ">>>> ${plugin}"
        bash ${SCRIPT_DIR}/install-zip-plugin.sh ${plugin}
    done
fi
