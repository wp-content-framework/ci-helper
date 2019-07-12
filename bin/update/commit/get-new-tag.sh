#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../../variables.sh

if [[ ! -d ${TRAVIS_BUILD_DIR}/.git ]]; then
	echo "Repository is not exist"
	exit 1
fi

git -C ${TRAVIS_BUILD_DIR} fetch -p --tags
LAST_TAG=$(git -C ${TRAVIS_BUILD_DIR} for-each-ref --sort=taggerdate --format='%(tag)' refs/tags | grep "^v[0-9]\+\.[0-9]\+\.[0-9]\+" | tail -n 1)

bash ${current}/generate-new-tag.sh ${LAST_TAG}
