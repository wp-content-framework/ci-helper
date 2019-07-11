#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/variables.sh

bash ${SCRIPT_DIR}/php/phpcs.sh
bash ${SCRIPT_DIR}/php/phpmd.sh
bash ${SCRIPT_DIR}/php/wp-test.sh

bash ${SCRIPT_DIR}/js/js-lint.sh
bash ${SCRIPT_DIR}/js/js-test.sh

source ${SCRIPT_DIR}/deploy/env.sh
bash ${SCRIPT_DIR}/deploy/create.sh

ls -la ${PACKAGE_DIR}
ls -la ${TRAVIS_BUILD_DIR}/${RELEASE_FILE}

bash ${SCRIPT_DIR}/deploy/wp-check-diff.sh

bash ${SCRIPT_DIR}/deploy/clear_work_dir.sh
rm -f ${RELEASE_FILE}
