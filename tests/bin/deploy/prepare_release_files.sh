#!/usr/bin/env bash

set -ex

if [[ -z "${TRAVIS_BUILD_DIR}" ]]; then
	echo "<TRAVIS_BUILD_DIR> is required"
	exit 1
fi

SCRIPT_DIR=${1}
source ${SCRIPT_DIR}/variables.sh

rm -rdf ${PACKAGE_DIR}/assets
rm -rdf ${PACKAGE_DIR}/vendor

rm -rdf ${TRAVIS_BUILD_DIR}/gh-pages/gutenberg/node_modules

cp -r ${TRAVIS_BUILD_DIR}/bin ${PACKAGE_DIR}/
cp -r ${TRAVIS_BUILD_DIR}/gh-pages ${PACKAGE_DIR}/
cp -r ${TRAVIS_BUILD_DIR}/settings ${PACKAGE_DIR}/
cp -r ${TRAVIS_BUILD_DIR}/tests ${PACKAGE_DIR}/

cp ${TRAVIS_BUILD_DIR}/LICENSE ${PACKAGE_DIR}/
cp ${TRAVIS_BUILD_DIR}/README.md ${PACKAGE_DIR}/
cp ${TRAVIS_BUILD_DIR}/.travis-sample.yml ${PACKAGE_DIR}/
cp ${TRAVIS_BUILD_DIR}/composer-sample.json ${PACKAGE_DIR}/
cp ${TRAVIS_BUILD_DIR}/package-sample.json ${PACKAGE_DIR}/

rm -rdf ${PACKAGE_DIR}/tests/bin
