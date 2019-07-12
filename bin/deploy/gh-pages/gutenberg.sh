#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../../variables.sh

if [[ ! -f ${GH_PAGES_DIR}/package.json ]]; then
    exit
fi

GH_WORK_DIR=${CACHE_WORK_DIR}/playground

rm -rdf ${GH_WORK_DIR}/src
rm -rdf ${GH_WORK_DIR}/stylesheets

svn export https://github.com/WordPress/gutenberg/trunk/playground/src ${GH_WORK_DIR}/src
svn export https://github.com/WordPress/gutenberg/trunk/assets/stylesheets ${GH_WORK_DIR}/stylesheets

sed -i -e 's/..\/..\/assets/./g' ${GH_WORK_DIR}/src/style.scss
mv -f ${GH_WORK_DIR}/src/* ${GH_WORK_DIR}/
mv -f ${GH_WORK_DIR}/src/.??* ${GH_WORK_DIR}/ 2> /dev/null || :
mv -n ${GH_PAGES_DIR}/yarn.lock ${GH_WORK_DIR}/ 2> /dev/null || :
rm -f ${GH_PAGES_DIR}/yarn.lock
mv -f ${GH_PAGES_DIR}/* ${GH_WORK_DIR}/
mv -f ${GH_PAGES_DIR}/.??* ${GH_WORK_DIR}/ 2> /dev/null || :

yarn --cwd ${GH_WORK_DIR} install
yarn --cwd ${GH_WORK_DIR} build

mv -f ${GH_WORK_DIR}/index.html ${GH_PAGES_DIR}/
mv -f ${GH_WORK_DIR}/setup.min.js ${GH_PAGES_DIR}/
mv -f ${GH_WORK_DIR}/editor.min.js ${GH_PAGES_DIR}/
