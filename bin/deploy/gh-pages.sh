#!/usr/bin/env bash

set -e

if [[ $# -lt 2 ]]; then
	echo "usage: $0 <key> <iv>"
	exit 1
fi

if [[ -z "${TRAVIS_BUILD_DIR}" ]]; then
    echo "<TRAVIS_BUILD_DIR> is required"
    exit
fi

if [[ ! -f ${TRAVIS_BUILD_DIR}/tests/bin/gh-pages.sh ]]; then
    echo "There is no setting file"
    exit
fi

current=$(cd $(dirname $0);
pwd)

echo ""
echo ">> Clone gh-pages"
rm -rdf ${GH_PAGES_DIR}
if [[ -n $(git -C ${TRAVIS_BUILD_DIR} branch -r | grep "gh-pages") ]]; then
    git clone -b gh-pages "https://github.com/${TRAVIS_REPO_SLUG}.git" ${GH_PAGES_DIR}
else
    mkdir ${GH_PAGES_DIR}
    git -C ${GH_PAGES_DIR} init
    git -C ${GH_PAGES_DIR} checkout -b gh-pages
fi

echo ""
echo ">> Prepare files"
bash ${TRAVIS_BUILD_DIR}/tests/bin/gh-pages.sh

echo ""
echo ">> Check diff"
if [[ -z "$(git -C ${GH_PAGES_DIR} status --short)" ]]; then
	echo "There is no diff"
	exit
fi

if [[ -z "${CI}" ]]; then
	git -C ${GH_PAGES_DIR} status --short
	echo "Prevent commit if local"
	exit
fi

echo ""
echo ">> Commit"
${current}/setup-git-configs.sh ${1} ${2}
git -C ${GH_PAGES_DIR} add --all
git -C ${GH_PAGES_DIR} status --short
git -C ${GH_PAGES_DIR} commit -m "${GH_PAGES_COMMIT_MESSAGE}"

echo ""
echo ">> Push"
git -C ${GH_PAGES_DIR} push -u origin gh-pages
