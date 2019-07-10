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
INSTALL=${1-""}

echo ""
echo ">> Copy files"
files=()
files+=( ".coveralls.yml" )
files+=( "phpmd.xml" )
files+=( "phpunit.xml" )
for file in "${files[@]}"
do
    if [[ ! -f ${TRAVIS_BUILD_DIR}/${file} ]]; then
        echo ">>>> ${file}"
        cp ${SETTINGS_DIR}/${file} ${TRAVIS_BUILD_DIR}/${file}
    fi
done
if [[ ! -f ${TRAVIS_BUILD_DIR}/phpcs.xml ]]; then
    echo ">>>> phpcs.xml"
    if [[ -d ${TRAVIS_BUILD_DIR}/configs ]]; then
        cp ${SETTINGS_DIR}/phpcs.xml ${TRAVIS_BUILD_DIR}/phpcs.xml
    else
        cp ${SETTINGS_DIR}/phpcs_no_configs.xml ${TRAVIS_BUILD_DIR}/phpcs.xml
    fi
fi

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

if [[ -n "${TRAVIS_BUILD_STAGE_NAME}" ]] && [[ ! "${TRAVIS_BUILD_STAGE_NAME}" =~ ^Test ]]; then
    INSTALL=""
fi
if [[ -n "${ACTIVATE_POPULAR_PLUGINS}" ]] || [[ -n "${INSTALL}" ]]; then
    echo ""
    echo ">> Install node11"
    nvm install 11
    npm install

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
