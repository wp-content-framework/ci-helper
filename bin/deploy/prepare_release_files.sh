#!/usr/bin/env bash

set -e

if [[ -z "${PACKAGE_DIR}" ]] || [[ -z "${RELEASE_FILE}" ]]; then
	echo "<PACKAGE_DIR> and <RELEASE_FILE> are required."
	exit 1
fi

echo ""
echo ">> Run composer install."
composer install --no-dev --working-dir=${TRAVIS_BUILD_DIR}

if [[ -f ${TRAVIS_BUILD_DIR}/assets/js/package.json ]]; then
    echo ""
    echo ">> Run yarn install."
    yarn install --audit --cwd ${TRAVIS_BUILD_DIR}/assets/js

    echo ""
    echo ">> Run yarn build."
    yarn build --cwd ${TRAVIS_BUILD_DIR}/assets/js
fi

rm -rdf ${PACKAGE_DIR}
rm -f ${RELEASE_FILE}
mkdir -p ${PACKAGE_DIR}/assets/js/

cp -r ${TRAVIS_BUILD_DIR}/assets/css ${PACKAGE_DIR}/assets/ 2> /dev/null || :
cp -r ${TRAVIS_BUILD_DIR}/assets/img ${PACKAGE_DIR}/assets/ 2> /dev/null || :
cp ${TRAVIS_BUILD_DIR}/assets/js/*.min.js ${PACKAGE_DIR}/assets/js/ 2> /dev/null || :
cp ${TRAVIS_BUILD_DIR}/assets/js/.htaccess ${PACKAGE_DIR}/assets/js/ 2> /dev/null || :
cp ${TRAVIS_BUILD_DIR}/assets/.htaccess ${PACKAGE_DIR}/assets/ 2> /dev/null || :

cp -r ${TRAVIS_BUILD_DIR}/configs ${PACKAGE_DIR}/ 2> /dev/null || :
cp -r ${TRAVIS_BUILD_DIR}/languages ${PACKAGE_DIR}/ 2> /dev/null || :
cp -r ${TRAVIS_BUILD_DIR}/src ${PACKAGE_DIR}/ 2> /dev/null || :
cp -r ${TRAVIS_BUILD_DIR}/vendor ${PACKAGE_DIR}/ 2> /dev/null || :

cp ${TRAVIS_BUILD_DIR}/*.php ${PACKAGE_DIR}/ 2> /dev/null || :
cp ${TRAVIS_BUILD_DIR}/*.gif ${PACKAGE_DIR}/ 2> /dev/null || :
cp ${TRAVIS_BUILD_DIR}/*.png ${PACKAGE_DIR}/ 2> /dev/null || :

cp ${TRAVIS_BUILD_DIR}/.htaccess ${PACKAGE_DIR}/ 2> /dev/null || :
cp ${TRAVIS_BUILD_DIR}/LICENSE ${PACKAGE_DIR}/ 2> /dev/null || :
cp ${TRAVIS_BUILD_DIR}/readme.txt ${PACKAGE_DIR}/ 2> /dev/null || :

rm -f ${PACKAGE_DIR}/index.php
rm -rdf ${PACKAGE_DIR}/vendor/bin

if [[ -n "${TRAVIS_BUILD_DIR}" && -f ${TRAVIS_BUILD_DIR}/tests/bin/deploy/prepare_release_files.sh ]]; then
    bash ${TRAVIS_BUILD_DIR}/tests/bin/deploy/prepare_release_files.sh
fi
