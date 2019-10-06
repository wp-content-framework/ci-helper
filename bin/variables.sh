#!/usr/bin/env bash

set -e

if [[ -z "${TRAVIS_BUILD_DIR}" ]]; then
	echo "<TRAVIS_BUILD_DIR> is required"
	exit 1
fi

if [[ -z "${TRAVIS_REPO_SLUG}" ]]; then
  REPO_NAME=${GITHUB_REPOSITORY##*/}
else
  REPO_NAME=${TRAVIS_REPO_SLUG##*/}
fi
WORK_DIR=${TRAVIS_BUILD_DIR}/.work
CACHE_WORK_DIR=${TRAVIS_BUILD_DIR}/.work/cache
GH_WORK_DIR=${CACHE_WORK_DIR}/playground
PACKAGE_DIR_NAME=packages
PACKAGE_DIR=${WORK_DIR}/${PACKAGE_DIR_NAME}/${REPO_NAME}
SVN_DIR=${WORK_DIR}/svn
GH_PAGES_DIR=${TRAVIS_BUILD_DIR}/gh-pages
PLUGIN_TESTS_DIR=${TRAVIS_BUILD_DIR}/tests
ASSETS_DIR=${TRAVIS_BUILD_DIR}/assets
BIN_DIR=${TRAVIS_BUILD_DIR}/bin
JS_DIR=${ASSETS_DIR}/js
CSS_DIR=${ASSETS_DIR}/css
IMG_DIR=${ASSETS_DIR}/img
if [[ ! -f ${JS_DIR}/package.json ]] && [[ -f ${TRAVIS_BUILD_DIR}/package.json ]]; then
    JS_DIR=${TRAVIS_BUILD_DIR}
fi

LIBRARY_BASE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/..; pwd -P)
SETTINGS_DIR=${LIBRARY_BASE_DIR}/settings
TESTS_DIR=${LIBRARY_BASE_DIR}/tests
SCRIPT_DIR=${LIBRARY_BASE_DIR}/bin
GH_PAGES_TEMPLATE_DIR=${LIBRARY_BASE_DIR}/gh-pages

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
