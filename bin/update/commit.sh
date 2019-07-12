#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

if [[ -z "${CI}" ]]; then
	git -C ${TRAVIS_BUILD_DIR} status --short
	echo "Prevent commit if local"
	exit
fi

echo ""
echo ">> Check diff"
git -C ${TRAVIS_BUILD_DIR} checkout master
if [[ -z "$(git -C ${TRAVIS_BUILD_DIR} status --short)" ]]; then
	echo "There is no diff"
	exit
fi

echo ""
echo ">> Commit"
git -C ${TRAVIS_BUILD_DIR} add --all
git -C ${TRAVIS_BUILD_DIR} status --short
git -C ${TRAVIS_BUILD_DIR} commit -m "${COMMIT_MESSAGE}"

echo ""
echo ">> Create new tag"
bash ${current}/commit/get-new-tag.sh | xargs --no-run-if-empty -I {} git tag -a {} -m "${TAG_MESSAGE}"

echo ""
echo ">> Push"
git -C ${TRAVIS_BUILD_DIR} push origin master --tags
