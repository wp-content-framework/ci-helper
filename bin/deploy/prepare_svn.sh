#!/usr/bin/env bash

set -e

current=$(
  cd $(dirname $0)
  pwd
)
source ${current}/../variables.sh

if [[ -z "${SVN_DIR}" ]]; then
  echo "<SVN_DIR> is required."
  exit 1
fi

if [[ -d ${SVN_DIR} ]]; then
  chmod -R +w ${SVN_DIR}
  rm -rdf ${SVN_DIR}
fi

if [[ -z "${SVN_URL}" ]]; then
  echo "<SVN_URL> is required."
  exit
fi

if [[ -z "${SVN_USER}" ]] || [[ -z "${SVN_PASS}" ]]; then
  echo "<SVN_USER>, <SVN_PASS> are required."
  exit
fi

set +e
if [[ -z $(svn ls ${SVN_URL}) ]]; then
  echo "repository [${SVN_URL}] is not exists."
  exit
fi
set -e

echo ""
echo ">> Run svn checkout."
mkdir -p ${SVN_DIR}
svn co -q ${SVN_URL}/trunk ${SVN_DIR}

echo ""
echo ">> Prepare release files."
bash ${SCRIPT_DIR}/deploy/prepare_release_files.sh

echo ""
echo ">> Sync build files to svn."
rsync -a --exclude=".svn" --checksum --delete ${PACKAGE_DIR}/ ${SVN_DIR}/

pushd ${SVN_DIR}

echo ""
echo ">> Run svn del."
svn st | grep '^!' | sed -e 's/^\!\s*/svn del -q /g' | sh

echo ""
echo ">> Run svn add."
svn st | grep '^?' | sed -e 's/^\?\s*/svn add -q /g' | sh

pushd
