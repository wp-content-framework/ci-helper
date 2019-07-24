#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

if [[ ! -f ${JS_DIR}/package.json ]]; then
    echo "package.json is required. "
    exit
fi

if [[ -z $(yarn --cwd ${JS_DIR} --non-interactive run | grep "\- cover$") ]]; then
	echo "yarn cover command is invalid."
	exit
fi

bash ${SCRIPT_DIR}/js/install-npm.sh
ls -la ${JS_DIR}/node_modules/.bin

echo ""
echo ">> Run yarn test."
yarn --cwd ${JS_DIR} cover

if [[ ! -z "${COVERAGE_REPORT}" ]] && [[ ! -z "${CI}" ]]; then
	ls -la ${JS_DIR}/coverage/lcov.info
	echo ""
	echo ">> Run yarn coveralls."
	yarn --cwd ${JS_DIR} coveralls
fi
