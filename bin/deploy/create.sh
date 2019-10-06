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
ls -lat ${WORK_DIR}/${PACKAGE_DIR_NAME}
ls -lat ${PACKAGE_DIR}

echo ""
echo ">> Create zip file."
cd ${WORK_DIR}/${PACKAGE_DIR_NAME} && zip -9 -qr ${TRAVIS_BUILD_DIR}/${RELEASE_FILE} ${REPO_NAME}
cd ${TRAVIS_BUILD_DIR}

ls -la ${RELEASE_FILE}
