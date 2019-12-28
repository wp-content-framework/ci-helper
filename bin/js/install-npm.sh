#!/usr/bin/env bash

set -e

current=$(
  cd $(dirname $0)
  pwd
)
source ${current}/../variables.sh

echo ""
echo ">> Run yarn install."
if [[ -n "${CI}" ]] && [[ -z "${GITHUB_ACTION}" ]]; then
  yarn --cwd ${JS_DIR} cache clean
fi
yarn --cwd ${JS_DIR} install
