#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

if [[ ! -f ${TRAVIS_BUILD_DIR}/assets/js/package.json ]]; then
    echo "package.json is required. "
    exit
fi

if [[ -z $(yarn --cwd ${TRAVIS_BUILD_DIR}/assets/js --non-interactive run | grep "\- lint$") ]]; then
	echo "yarn lint command is invalid."
	exit
fi

bash ${SCRIPT_DIR}/js/install-npm.sh
ls -la ${TRAVIS_BUILD_DIR}/assets/js/node_modules/.bin/webpack

echo ""
echo ">> Run yarn lint."
yarn --cwd ${TRAVIS_BUILD_DIR}/assets/js lint
