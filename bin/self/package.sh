#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

TARGET_DIR=${GH_PAGES_TEMPLATE_DIR}/gutenberg

sed -i -e '/@wordpress/d' ${TARGET_DIR}/package.json

URL=https://api.wp-framework.dev/api/v1/summary.json
packages="$(curl $(curl ${URL} | jq -r '.gutenberg.url') | jq -r '.|keys[]' | paste -sd " " - | sed 's/wp-/@wordpress\//g')"
packages="${packages} @wordpress/babel-plugin-import-jsx-pragma"

yarn --cwd ${TARGET_DIR} add ${packages} --dev

bash ${SCRIPT_DIR}/update/package.sh ${TARGET_DIR}
