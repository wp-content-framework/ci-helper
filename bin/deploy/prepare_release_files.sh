#!/usr/bin/env bash

set -e

current=$(
  cd $(dirname $0)
  pwd
)
source ${current}/../variables.sh

if [[ -z "${PACKAGE_DIR}" ]] || [[ -z "${RELEASE_FILE}" ]]; then
  echo "<PACKAGE_DIR> and <RELEASE_FILE> are required."
  exit 1
fi

if [[ -f ${TRAVIS_BUILD_DIR}/composer.json ]]; then
  echo ""
  echo ">> Run composer install."
  composer install --no-dev --working-dir=${TRAVIS_BUILD_DIR}
fi

if [[ -f ${JS_DIR}/package.json ]] && [[ -n $(yarn --cwd ${JS_DIR} --non-interactive run | grep "\- build$") ]]; then
  echo ""
  echo ">> Run yarn install."
  if [[ -n "${CI}" ]] && [[ -z "${GITHUB_ACTION}" ]]; then
    yarn --cwd ${JS_DIR} cache clean
  fi
  yarn --cwd ${JS_DIR} install

  echo ""
  echo ">> Run yarn build."
  yarn --cwd ${JS_DIR} build
fi

rm -rdf ${PACKAGE_DIR}
rm -f ${RELEASE_FILE}
mkdir -p ${PACKAGE_DIR}/assets/js/

cp -r ${TRAVIS_BUILD_DIR}/assets/css ${PACKAGE_DIR}/assets/ 2>/dev/null || :
cp -r ${TRAVIS_BUILD_DIR}/assets/img ${PACKAGE_DIR}/assets/ 2>/dev/null || :
cp ${TRAVIS_BUILD_DIR}/assets/js/*.min.js ${PACKAGE_DIR}/assets/js/ 2>/dev/null || :
cp ${TRAVIS_BUILD_DIR}/assets/js/.htaccess ${PACKAGE_DIR}/assets/js/ 2>/dev/null || :
cp ${TRAVIS_BUILD_DIR}/assets/.htaccess ${PACKAGE_DIR}/assets/ 2>/dev/null || :

cp -r ${TRAVIS_BUILD_DIR}/configs ${PACKAGE_DIR}/ 2>/dev/null || :
cp -r ${TRAVIS_BUILD_DIR}/languages ${PACKAGE_DIR}/ 2>/dev/null || :
cp -r ${TRAVIS_BUILD_DIR}/src ${PACKAGE_DIR}/ 2>/dev/null || :
cp -r ${TRAVIS_BUILD_DIR}/vendor ${PACKAGE_DIR}/ 2>/dev/null || :

cp ${TRAVIS_BUILD_DIR}/*.php ${PACKAGE_DIR}/ 2>/dev/null || :
cp ${TRAVIS_BUILD_DIR}/*.gif ${PACKAGE_DIR}/ 2>/dev/null || :
cp ${TRAVIS_BUILD_DIR}/*.png ${PACKAGE_DIR}/ 2>/dev/null || :

cp ${TRAVIS_BUILD_DIR}/.htaccess ${PACKAGE_DIR}/ 2>/dev/null || :
cp ${TRAVIS_BUILD_DIR}/LICENSE ${PACKAGE_DIR}/ 2>/dev/null || :
cp ${TRAVIS_BUILD_DIR}/readme.txt ${PACKAGE_DIR}/ 2>/dev/null || :

rm -f ${PACKAGE_DIR}/index.php
rm -rdf ${PACKAGE_DIR}/vendor/bin

if [[ -n "${TRAVIS_BUILD_DIR}" && -f ${TRAVIS_BUILD_DIR}/tests/bin/deploy/prepare_release_files.sh ]]; then
  bash ${TRAVIS_BUILD_DIR}/tests/bin/deploy/prepare_release_files.sh ${SCRIPT_DIR}
fi
