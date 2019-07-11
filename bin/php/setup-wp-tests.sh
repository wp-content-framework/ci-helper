#!/usr/bin/env bash

set -e

current=$(cd $(dirname $0);
pwd)
source ${current}/../variables.sh

if [[ -f ~/.phpenv/versions/$(phpenv version-name)/etc/conf.d/xdebug.ini ]]; then
	if [[ -z "${COVERAGE_REPORT}" ]]; then
		phpenv config-rm xdebug.ini
	fi
else
	echo "xdebug.ini does not exist"
fi

bash ${SCRIPT_DIR}/php/install-wp-tests.sh wordpress_test root '' localhost ${WP_VERSION}
bash ${SCRIPT_DIR}/php/install-composer.sh
