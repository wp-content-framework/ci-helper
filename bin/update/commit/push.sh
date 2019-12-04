#!/usr/bin/env bash

set -e

current=$(
  cd $(dirname $0)
  pwd
)
source ${current}/../../variables.sh

COMMIT_TARGET_DIR=${1-""}
GIT_DIR=${2-${TRAVIS_BUILD_DIR}}

if [[ ! -d ${GIT_DIR}/.git ]]; then
  echo "Repository is not exist"
  exit 1
fi

if [[ -f ${BIN_DIR}/commit/push.sh ]]; then
  bash ${BIN_DIR}/commit/push.sh ${COMMIT_TARGET_DIR} ${GIT_DIR}
else
  git -C ${GIT_DIR} push origin master --tags
fi
