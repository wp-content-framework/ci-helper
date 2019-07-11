#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../../variables.sh

if [[ ! -f ${GH_PAGES_DIR}/package.json ]]; then
    exit
fi

svn export https://github.com/WordPress/gutenberg/trunk/playground/src ${WORK_DIR}/playground
svn export https://github.com/WordPress/gutenberg/trunk/assets/stylesheets ${GH_PAGES_DIR}/stylesheets
rm -f ${WORK_DIR}/playground/index.html
mv -f ${WORK_DIR}/playground/* ${GH_PAGES_DIR}/
sed -i -e 's/..\/..\/assets/./g' ${GH_PAGES_DIR}/style.scss

yarn --cwd ${GH_PAGES_DIR} install
yarn --cwd ${GH_PAGES_DIR} build

rm -f ${GH_PAGES_DIR}/*.scss
rm -f ${GH_PAGES_DIR}/*.json
rm -f ${GH_PAGES_DIR}/*.config.js
rm -f ${GH_PAGES_DIR}/.*
