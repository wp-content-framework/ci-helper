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

if [[ -f ${BIN_DIR}/commit/create-new-tag.sh ]]; then
  bash ${BIN_DIR}/commit/create-new-tag.sh ${COMMIT_TARGET_DIR} ${GIT_DIR} ${TAG_MESSAGE}
else
  bash ${current}/get-new-tag.sh | xargs -I {} git tag -a {} -m "${TAG_MESSAGE}"
fi
