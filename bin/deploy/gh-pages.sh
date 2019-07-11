#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

GH_PAGES_TEMPLATE=${GH_PAGES_TEMPLATE:-"page"}
GH_PAGES_TITLE=${GH_PAGES_TITLE:-"Sample page"}
GH_PAGES_EDITOR_SCRIPT=${GH_PAGES_EDITOR_SCRIPT:-"./index.min.js"}
GH_PAGES_PLUGIN_SCRIPT=${GH_PAGES_PLUGIN_SCRIPT:-""}
GH_PAGES_APP_ID=${GH_PAGES_APP_ID:-"app"}

echo ""
echo ">> Prepare files"
rm -rdf ${GH_PAGES_DIR}

if [[ -d ${GH_PAGES_TEMPLATE_DIR}/${GH_PAGES_TEMPLATE} ]]; then
    cp -a ${GH_PAGES_TEMPLATE_DIR}/${GH_PAGES_TEMPLATE} ${GH_PAGES_DIR}
else
    mkdir -p ${GH_PAGES_DIR}
fi

if [[ -f ${PLUGIN_TESTS_DIR}/bin/gh-pages/pre_setup.sh ]]; then
    bash ${PLUGIN_TESTS_DIR}/bin/gh-pages/pre_setup.sh
fi

if [[ -f ${SCRIPT_DIR}/deploy/gh-pages/${GH_PAGES_TEMPLATE}.sh ]]; then
    bash ${SCRIPT_DIR}/deploy/gh-pages/${GH_PAGES_TEMPLATE}.sh
fi

if [[ -f ${PLUGIN_TESTS_DIR}/bin/gh-pages/setup.sh ]]; then
    bash ${PLUGIN_TESTS_DIR}/bin/gh-pages/setup.sh
fi

find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e 's/${__title__}/'${GH_PAGES_TITLE//\//\\/}'/g' file
find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e 's/${__editor_script__}/'${GH_PAGES_EDITOR_SCRIPT//\//\\/}'/g' file
find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e 's/${__app_id__}/'${GH_PAGES_APP_ID//\//\\/}'/g' file

if [[ -n "${GH_PAGES_PLUGIN_SCRIPT}" ]]; then
    find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e 's/${__plugin_script__}/'${GH_PAGES_PLUGIN_SCRIPT//\//\\/}'/g' file
else
    find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -e '/${__plugin_script__}/d' file
fi
