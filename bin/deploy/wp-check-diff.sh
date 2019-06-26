#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0})/..; pwd -P)
bash ${SCRIPT_DIR}/deploy/prepare_svn.sh

if [[ ! -d ${SVN_DIR} ]]; then
	exit;
fi

pushd ${SVN_DIR}

echo ""
echo ">> Run svn st."
svn st

pushd

bash ${SCRIPT_DIR}/deploy/clear_work_dir.sh
