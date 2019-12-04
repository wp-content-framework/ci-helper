#!/usr/bin/env bash

set -e

current=$(
  cd $(dirname $0)
  pwd
)
source ${current}/../variables.sh

COMMIT_TARGET_DIR=${1-""}
GIT_DIR=${2-${TRAVIS_BUILD_DIR}}

if [[ ! -d ${GIT_DIR}/.git ]]; then
  echo "Repository is not exist"
  exit 1
fi

if [[ -n "${COMMIT_TARGET_DIR}" ]] && [[ ! -d ${COMMIT_TARGET_DIR} ]]; then
  echo "Target directory is not exist"
  exit 1
fi

if [[ -z "${CI}" ]]; then
  diff=$(bash ${current}/commit/get-diff.sh ${COMMIT_TARGET_DIR} ${GIT_DIR})
  if [[ -z "${diff}" ]]; then
    echo "There is no diff"
  else
    echo "${diff}"
  fi
  echo "Prevent commit if local"
  exit
fi

echo ""
echo ">> Check diff"
if [[ -z "${COMMIT_TARGET_DIR}" ]] && [[ -f ${GIT_DIR}/composer.json ]]; then
  git -C ${GIT_DIR} checkout composer.json
fi
if [[ -z "$(bash ${current}/commit/get-diff.sh ${COMMIT_TARGET_DIR} ${GIT_DIR})" ]]; then
  echo "There is no diff"
  exit
fi

echo ""
echo ">> Commit"
bash ${current}/commit/git-add.sh ${COMMIT_TARGET_DIR} ${GIT_DIR}
if [[ -z "$(bash ${current}/commit/get-diff.sh ${COMMIT_TARGET_DIR} ${GIT_DIR})" ]]; then
  echo "There is no diff"
  exit
fi
git -C ${GIT_DIR} commit -m "${COMMIT_MESSAGE}"

echo ""
echo ">> Create new tag"
bash ${current}/commit/create-new-tag.sh ${COMMIT_TARGET_DIR} ${GIT_DIR}

echo ""
echo ">> Push"
bash ${current}/commit/push.sh ${COMMIT_TARGET_DIR} ${GIT_DIR}
