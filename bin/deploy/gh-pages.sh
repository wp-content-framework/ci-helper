#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

GH_PAGES_TEMPLATE=${GH_PAGES_TEMPLATE:-"page"}
GH_PAGES_TITLE=${GH_PAGES_TITLE:-"Sample page"}
GH_PAGES_SCRIPT=${GH_PAGES_TITLE:-"./index.js"}
GH_PAGES_APP_ID=${GH_PAGES_TITLE:-"app"}

echo ""
echo ">> Prepare files"
rm -rdf ${GH_PAGES_DIR}

if [[ -d ${GH_PAGES_TEMPLATE_DIR}/${GH_PAGES_TEMPLATE} ]]; then
    cp -a ${GH_PAGES_TEMPLATE_DIR}/${GH_PAGES_TEMPLATE} ${GH_PAGES_DIR}
else
    mkdir -p ${GH_PAGES_DIR}
fi

if [[ -f ${SCRIPT_DIR}/deploy/gh-pages/${GH_PAGES_TEMPLATE} ]]; then
    bash ${SCRIPT_DIR}/deploy/gh-pages/${GH_PAGES_TEMPLATE}
fi

if [[ -f ${PLUGIN_TESTS_DIR}/bin/gh-pages.sh ]]; then
    bash ${PLUGIN_TESTS_DIR}/bin/gh-pages.sh
fi

find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e 's/${title}/'${GH_PAGES_TITLE//\//\\/}'/g'
find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e 's/${script}/'${GH_PAGES_SCRIPT//\//\\/}'/g'
find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e 's/${app_id}/'${GH_PAGES_APP_ID//\//\\/}'/g'
