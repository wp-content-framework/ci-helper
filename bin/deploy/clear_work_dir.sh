#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

if [[ -d ${WORK_DIR} ]]; then
	chmod -R +w ${WORK_DIR}
	rm -rdf ${WORK_DIR}
fi
