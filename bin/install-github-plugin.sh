#!/usr/bin/env bash

set -e

if [[ $# -lt 1 ]]; then
	echo "usage: $0 <github repo>"
	exit 1
fi

TESTS_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/../tests; pwd -P)
GITHUB_REPO=$1
PLUGIN_SLUG=${GITHUB_REPO##*/}

git clone --depth=1 https://github.com/${GITHUB_REPO}.git ${TESTS_DIR}/.plugin/${PLUGIN_SLUG}
