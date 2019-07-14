#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../../variables.sh

if [[ ! -f ${GH_PAGES_DIR}/package.json ]]; then
	exit
fi

mv -n ${GH_PAGES_DIR}/yarn.lock ${GH_WORK_DIR}/ 2> /dev/null || :
rm -f ${GH_PAGES_DIR}/yarn.lock
mv -f ${GH_PAGES_DIR}/* ${GH_WORK_DIR}/
mv -f ${GH_PAGES_DIR}/.??* ${GH_WORK_DIR}/ 2> /dev/null || :

yarn --cwd ${GH_WORK_DIR} install
yarn --cwd ${GH_WORK_DIR} build

mv -f ${GH_WORK_DIR}/index.html ${GH_PAGES_DIR}/
mv -f ${GH_WORK_DIR}/setup.min.js ${GH_PAGES_DIR}/
mv -f ${GH_WORK_DIR}/.htaccess ${GH_PAGES_DIR}/
