#!/usr/bin/env bash

set -e

if [[ -z "${TRAVIS_BUILD_DIR}" ]]; then
	echo "<TRAVIS_BUILD_DIR> is required"
	exit 1
fi

WORK_DIR=${TRAVIS_BUILD_DIR}/.work
CACHE_WORK_DIR=${TRAVIS_BUILD_DIR}/.work/cache
PACKAGE_DIR=${WORK_DIR}/packages
SVN_DIR=${WORK_DIR}/svn
GH_PAGES_DIR=${TRAVIS_BUILD_DIR}/gh-pages
PLUGIN_TESTS_DIR=${TRAVIS_BUILD_DIR}/tests

LIBRARY_BASE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/..; pwd -P)
SETTINGS_DIR=${LIBRARY_BASE_DIR}/settings
TESTS_DIR=${LIBRARY_BASE_DIR}/tests
SCRIPT_DIR=${LIBRARY_BASE_DIR}/bin
GH_PAGES_TEMPLATE_DIR=${LIBRARY_BASE_DIR}/gh-pages

REPO_NAME=${TRAVIS_REPO_SLUG##*/}
WP_TAG=${TRAVIS_TAG#v}
SVN_URL=https://plugins.svn.wordpress.org/${REPO_NAME}
SVN_COMMIT_MESSAGE="Commit release ${TRAVIS_TAG}"
SVN_TAG_MESSAGE="Take snapshot of ${TRAVIS_TAG}"
TAG_MESSAGE="Auto tag by Travis CI"
if [[ -n "${TRAVIS_BUILD_NUMBER}" ]]; then
	COMMIT_MESSAGE="feat: Update version data (Travis build: ${TRAVIS_BUILD_WEB_URL})"
else
	COMMIT_MESSAGE="feat: Update version data"
fi
