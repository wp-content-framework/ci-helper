#!/usr/bin/env bash

set -e

if [[ $# -lt 1 ]]; then
	echo "usage: $0 <zip url>"
	exit 1
fi

set -x

ZIP_URL=$1

curl -s ${ZIP_URL} -o ${TRAVIS_BUILD_DIR}/.plugin/plugin.zip
unzip ${TRAVIS_BUILD_DIR}/.plugin/plugin.zip -d ${TRAVIS_BUILD_DIR}/.plugin
rm -f ${TRAVIS_BUILD_DIR}/.plugin/plugin.zip
