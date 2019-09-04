#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../../variables.sh

if [[ ! -f ${GH_WORK_DIR}/template/package.json ]]; then
	exit
fi

mv -n ${GH_WORK_DIR}/template/yarn.lock ${GH_WORK_DIR}/ 2> /dev/null || :
rm -f ${GH_WORK_DIR}/template/yarn.lock
mv -f ${GH_WORK_DIR}/template/* ${GH_WORK_DIR}/
mv -f ${GH_WORK_DIR}/template/.??* ${GH_WORK_DIR}/ 2> /dev/null || :

if [[ -f ${TRAVIS_BUILD_DIR}/bin/gh-pages/pre_install.sh ]]; then
    bash ${TRAVIS_BUILD_DIR}/bin/gh-pages/pre_install.sh ${SCRIPT_DIR}
fi

yarn --cwd ${GH_WORK_DIR} install
yarn --cwd ${GH_WORK_DIR} add --force node-sass
yarn --cwd ${GH_WORK_DIR} build

mv -f ${GH_WORK_DIR}/index.html ${GH_PAGES_DIR}/
mv -f ${GH_WORK_DIR}/setup.min.js ${GH_PAGES_DIR}/
mv -f ${GH_WORK_DIR}/.htaccess ${GH_PAGES_DIR}/
mv -f ${GH_WORK_DIR}/favicon.ico ${GH_PAGES_DIR}/
