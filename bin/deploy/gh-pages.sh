#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

if [[ $# -lt 1 ]]; then
	echo "usage: $0 <template>"
	exit 1
fi

echo ""
echo ">> Prepare files"
rm -rdf ${GH_PAGES_DIR}
template=${1}

if [[ -d ${GH_PAGES_TEMPLATE_DIR}/${template} ]]; then
    cp -a ${GH_PAGES_TEMPLATE_DIR}/${template} ${GH_PAGES_DIR}
else
    mkdir -p ${GH_PAGES_DIR}
fi

if [[ -f ${SCRIPT_DIR}/deploy/gh-pages/${template} ]]; then
    bash ${SCRIPT_DIR}/deploy/gh-pages/${template}
fi

if [[ -f ${PLUGIN_TESTS_DIR}/bin/gh-pages.sh ]]; then
    bash ${PLUGIN_TESTS_DIR}/bin/gh-pages.sh
fi
