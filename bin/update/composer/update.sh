#!/usr/bin/env bash

set -e

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <package> [working dir]"
  exit 1
fi

current=$(
  cd $(dirname $0)
  pwd
)
source ${current}/../../variables.sh

package=${1}
working_dir=${2-${TRAVIS_BUILD_DIR}}

composer require --working-dir=${working_dir} --update-no-dev ${package}
