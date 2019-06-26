#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/..; pwd -P)

echo ""
echo ">> Prepare release files."
bash ${SCRIPT_DIR}/deploy/prepare_release_files.sh

pushd ${PACKAGE_DIR}
echo ""
echo ">> Create zip file."
zip -9 -qr ${TRAVIS_BUILD_DIR}/${RELEASE_FILE} .
pushd

ls -la ${RELEASE_FILE}
