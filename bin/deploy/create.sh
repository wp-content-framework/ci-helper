#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

if [[ -z "${RELEASE_FILE}" ]]; then
	echo "<RELEASE_FILE> is required."
	exit 1
fi

echo ""
echo ">> Prepare release files."
bash ${SCRIPT_DIR}/deploy/prepare_release_files.sh

pushd ${PACKAGE_DIR}
echo ""
echo ">> Create zip file."
zip -9 -qr ${TRAVIS_BUILD_DIR}/${RELEASE_FILE} .
pushd

ls -la ${RELEASE_FILE}
