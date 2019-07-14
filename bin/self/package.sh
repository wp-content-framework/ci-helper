#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

TARGET_DIR=${GH_PAGES_TEMPLATE_DIR}/gutenberg

URL=https://api.wp-framework.dev/api/v1/summary.json
data=$(curl $(curl ${URL} | jq -r '.gutenberg.url'))

packages="$(echo "${data}" | jq -r '.|keys[]' | paste -sd " " - | sed 's/wp-/@wordpress\//g')"
packages="${packages} @wordpress/babel-plugin-import-jsx-pragma"
sed -i -e '/@wordpress/d' ${TARGET_DIR}/package.json
yarn --cwd ${TARGET_DIR} add ${packages} --dev
bash ${SCRIPT_DIR}/update/package.sh ${TARGET_DIR}

echo "${data}"\
  | jq -r '. | keys[] | {"property":.|sub("wp-";"")|gsub( "-(?<a>[a-z])"; .a|ascii_upcase), "package":.|sub("wp-";"@wordpress/")} | "const " + .property + " = require( \"" + .package + "\" );"'\
 > ${GH_PAGES_TEMPLATE_DIR}/gutenberg/packages.js
echo 'const lodash = require( "lodash" );' >> ${GH_PAGES_TEMPLATE_DIR}/gutenberg/packages.js
echo '' >> ${GH_PAGES_TEMPLATE_DIR}/gutenberg/packages.js
echo 'window.wp = window.wp || {};' >> ${GH_PAGES_TEMPLATE_DIR}/gutenberg/packages.js
echo "${data}"\
  | jq -r '. | keys[] | sub("wp-";"") | gsub( "-(?<a>[a-z])"; .a|ascii_upcase) | "window.wp." + . + " = window.wp." + . + " || " + . + ";"'\
 >> ${GH_PAGES_TEMPLATE_DIR}/gutenberg/packages.js
echo 'window.lodash = window.lodash || lodash;' >> ${GH_PAGES_TEMPLATE_DIR}/gutenberg/packages.js
