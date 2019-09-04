#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

echo ""
echo ">> Run yarn install."
yarn --cwd ${JS_DIR} install
yarn --cwd ${JS_DIR} add --force node-sass
