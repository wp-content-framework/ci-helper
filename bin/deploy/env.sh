#!/usr/bin/env bash

set -e

export RELEASE_FILE=${REPO_NAME}.zip
export RELEASE_TITLE=${TRAVIS_TAG}
export RELEASE_TAG=${TRAVIS_TAG}
export GH_PAGES_DIR=${TRAVIS_BUILD_DIR}/gh-pages
