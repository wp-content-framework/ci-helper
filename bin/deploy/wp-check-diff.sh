#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)

bash ${current}/prepare_svn.sh

if [[ ! -d ${SVN_DIR} ]]; then
	exit;
fi

pushd ${SVN_DIR}

echo ""
echo ">> Run svn st."
svn st

pushd

bash ${current}/clear_work_dir.sh
