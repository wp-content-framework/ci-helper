#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

COMMIT_TARGET_DIR=${1-""}

if [[ -n "${COMMIT_TARGET_DIR}" ]] && [[ ! -d ${COMMIT_TARGET_DIR} ]]; then
    echo "Target directory is not exist"
    exit 1
fi

if [[ -z "${CI}" ]]; then
    diff=$(git -C ${TRAVIS_BUILD_DIR} status --short ${COMMIT_TARGET_DIR})
    if [[ -z "${diff}" ]]; then
        echo "There is no diff"
    else
        echo ${diff}
    fi
    echo "Prevent commit if local"
    exit
fi

echo ""
echo ">> Check diff"
git -C ${TRAVIS_BUILD_DIR} checkout master
if [[ -z "$(git -C ${TRAVIS_BUILD_DIR} status --short ${COMMIT_TARGET_DIR})" ]]; then
    echo "There is no diff"
    exit
fi

echo ""
echo ">> Commit"
if [[ -n "${COMMIT_TARGET_DIR}" ]]; then
    git -C ${TRAVIS_BUILD_DIR} add ${COMMIT_TARGET_DIR}
else
    git -C ${TRAVIS_BUILD_DIR} add --all
fi
git -C ${TRAVIS_BUILD_DIR} status --short ${COMMIT_TARGET_DIR}
git -C ${TRAVIS_BUILD_DIR} commit -m "${COMMIT_MESSAGE}"

echo ""
echo ">> Create new tag"
bash ${current}/commit/get-new-tag.sh | xargs --no-run-if-empty -I {} git tag -a {} -m "${TAG_MESSAGE}"

echo ""
echo ">> Push"
git -C ${TRAVIS_BUILD_DIR} push origin master --tags
