#!/usr/bin/env bash

set -e

current=$(
  cd $(dirname $0)
  pwd
)
source ${current}/../variables.sh

if [[ ! -f ${JS_DIR}/package.json ]]; then
  echo "package.json is required. "
  exit
fi

if ! < "${JS_DIR}"/package.json jq -r '.scripts | keys[]' | grep -qe '^lint$'; then
  echo "yarn lint command is invalid."
  exit
fi

bash ${SCRIPT_DIR}/js/install-npm.sh
ls -la ${JS_DIR}/node_modules/.bin

echo ""
echo ">> Run yarn lint."
if [[ -n "${GIT_DIFF}" ]]; then
  # shellcheck disable=SC2046
  yarn --cwd ${JS_DIR} eslint $(eval echo "${GIT_DIFF}" | tr ' ' '\n' | sed 's/^assets\/js\///' | tr '\n' ' ')
else
  yarn --cwd ${JS_DIR} lint
fi
