#!/usr/bin/env bash

set -e

current=$(
  cd $(dirname $0)
  pwd
)
source ${current}/../variables.sh

TARGET_DIR=${GH_PAGES_TEMPLATE_DIR}/gutenberg

URL=https://api.wp-framework.dev/api/v1/summary.json
data=$(curl $(curl ${URL} | jq -r '.gutenberg.url'))
packages="$(echo "${data}" | jq -r '.|keys[]' | paste -sd " " - | sed 's/wp-/@wordpress\//g')"
packages="${packages} @wordpress/babel-plugin-import-jsx-pragma"
sed -i -e '/@wordpress/d' ${TARGET_DIR}/package.json
yarn --cwd ${TARGET_DIR} add ${packages} --dev
bash ${SCRIPT_DIR}/update/package.sh ${TARGET_DIR}

PACKAGES_FILE=${GH_PAGES_TEMPLATE_DIR}/gutenberg/packages.js
echo "${data}" |
  jq -r '. | keys[] | {"property":.|sub("wp-";"")|gsub( "-(?<a>[a-z])"; .a|ascii_upcase), "package":.|sub("wp-";"@wordpress/")} | "const " + .property + " = require( \"" + .package + "\" );"' \
    >${PACKAGES_FILE}
echo 'const lodash = require( "lodash" );' >>${PACKAGES_FILE}
echo '' >>${PACKAGES_FILE}
echo 'window.wp = window.wp || {};' >>${PACKAGES_FILE}
echo "${data}" |
  jq -r '. | keys[] | sub("wp-";"") | gsub( "-(?<a>[a-z])"; .a|ascii_upcase) | "window.wp." + . + " = window.wp." + . + " || " + . + ";"' \
    >>${PACKAGES_FILE}
echo 'window.lodash = window.lodash || lodash;' >>${PACKAGES_FILE}
sed -i -e 's/const domReady = require( "@wordpress\/dom-ready" )/import domReady from "@wordpress\/dom-ready"/' ${PACKAGES_FILE}

TARGET_DIR=${GH_PAGES_TEMPLATE_DIR}/page
bash ${SCRIPT_DIR}/update/package.sh ${TARGET_DIR}
