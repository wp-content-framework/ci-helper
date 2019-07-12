#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

GH_PAGES_TEMPLATE=${GH_PAGES_TEMPLATE:-"page"}
GH_PAGES_TITLE=${GH_PAGES_TITLE-"Sample page"}
GH_PAGES_SETUP_SCRIPT=${GH_PAGES_SETUP_SCRIPT-"./setup.min.js"}
GH_PAGES_EDITOR_SCRIPT=${GH_PAGES_EDITOR_SCRIPT-"./editor.min.js"}
GH_PAGES_PLUGIN_SCRIPT=${GH_PAGES_PLUGIN_SCRIPT-""}
GH_PAGES_PLUGIN_STYLE=${GH_PAGES_PLUGIN_STYLE-""}
GH_PAGES_APP_ID=${GH_PAGES_APP_ID:-"app"}

echo ""
echo ">> Prepare files"
rm -rdf ${GH_PAGES_DIR}

if [[ -d ${GH_PAGES_TEMPLATE_DIR}/${GH_PAGES_TEMPLATE} ]]; then
    cp -a ${GH_PAGES_TEMPLATE_DIR}/${GH_PAGES_TEMPLATE} ${GH_PAGES_DIR}
else
    mkdir -p ${GH_PAGES_DIR}
fi

if [[ -f ${TRAVIS_BUILD_DIR}/bin/gh-pages/pre_setup.sh ]]; then
    bash ${TRAVIS_BUILD_DIR}/bin/gh-pages/pre_setup.sh ${SCRIPT_DIR}
fi

if [[ -f ${SCRIPT_DIR}/deploy/gh-pages/${GH_PAGES_TEMPLATE}.sh ]]; then
    bash ${SCRIPT_DIR}/deploy/gh-pages/${GH_PAGES_TEMPLATE}.sh
fi

if [[ -f ${TRAVIS_BUILD_DIR}/bin/gh-pages/setup.sh ]]; then
    bash ${TRAVIS_BUILD_DIR}/bin/gh-pages/setup.sh ${SCRIPT_DIR}
fi

find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e "s/___title___/${GH_PAGES_TITLE//\//\\/}/g" file
find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e "s/___setup_script___/${GH_PAGES_SETUP_SCRIPT//\//\\/}/g" file
find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e "s/___editor_script___/${GH_PAGES_EDITOR_SCRIPT//\//\\/}/g" file
find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e "s/___app_id___/${GH_PAGES_APP_ID//\//\\/}/g" file

if [[ -n "${GH_PAGES_PLUGIN_SCRIPT}" ]]; then
    find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e "s/___plugin_script___/${GH_PAGES_PLUGIN_SCRIPT//\//\\/}/g" file
else
    find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e "/___plugin_script___/d" file
fi
if [[ -n "${GH_PAGES_PLUGIN_STYLE}" ]]; then
    find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e "s/___plugin_style___/${GH_PAGES_PLUGIN_STYLE//\//\\/}/g" file
else
    find ${GH_PAGES_DIR} -type f -print0 | xargs -n1 --no-run-if-empty -0 -I file sed -i -e "/___plugin_style___/d" file
fi
