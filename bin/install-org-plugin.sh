#!/usr/bin/env bash

## @link https://qiita.com/miya0001/items/35103fb5acc1e17a03de

set -e

if [[ $# -lt 1 ]]; then
	echo "usage: $0 <plugin slug> [plugin version]"
	exit 1
fi

PLUGIN_SLUG=$1
PLUGIN_VERSION=${2-latest}

if [[ ${PLUGIN_VERSION} = "latest" ]]; then
    WP_PLUGIN=$(curl "https://api.wordpress.org/plugins/info/1.0/${PLUGIN_SLUG}.json" | jq -r .download_link)
else
    WP_PLUGIN=https://downloads.wordpress.org/plugin/${PLUGIN_SLUG}.${PLUGIN_VERSION}.zip
fi

curl -s ${WP_PLUGIN} -o ${TRAVIS_BUILD_DIR}/.plugin/plugin.zip
unzip ${TRAVIS_BUILD_DIR}/.plugin/plugin.zip -d ${TRAVIS_BUILD_DIR}/.plugin
rm -f ${TRAVIS_BUILD_DIR}/.plugin/plugin.zip
