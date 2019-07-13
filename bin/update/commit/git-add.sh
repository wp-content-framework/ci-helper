#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../../variables.sh

COMMIT_TARGET_DIR=${1-""}
GIT_DIR=${2-${TRAVIS_BUILD_DIR}}

if [[ ! -d ${GIT_DIR}/.git ]]; then
	echo "Repository is not exist"
	exit 1
fi

if [[ -f ${BIN_DIR}/commit/git-add.sh ]]; then
    ${BIN_DIR}/commit/git-add.sh ${COMMIT_TARGET_DIR} ${GIT_DIR}
else
    if [[ -n "${COMMIT_TARGET_DIR}" ]]; then
        git -C ${GIT_DIR} add ${COMMIT_TARGET_DIR}
    else
        git -C ${GIT_DIR} add --all
    fi
fi
