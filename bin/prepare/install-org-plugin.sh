#!/usr/bin/env bash

## @link https://qiita.com/miya0001/items/35103fb5acc1e17a03de

set -e

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <plugin slug> [plugin version]"
  exit 1
fi

set -x

PLUGIN_SLUG=$1
PLUGIN_VERSION=${2-latest}

if [[ ${PLUGIN_VERSION} == "latest" ]]; then
  WP_PLUGIN=$(curl "https://api.wordpress.org/plugins/info/1.0/${PLUGIN_SLUG}.json" | jq -r .download_link)
else
  WP_PLUGIN=https://downloads.wordpress.org/plugin/${PLUGIN_SLUG}.${PLUGIN_VERSION}.zip
fi

FILE_NAME=${WP_PLUGIN##*/}
README=${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}/readme.txt

if [[ ! -f ${TRAVIS_BUILD_DIR}/.plugin/${FILE_NAME} ]]; then
  rm -f ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}.*.zip
  rm -rdf ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}
  curl -s ${WP_PLUGIN} -o ${TRAVIS_BUILD_DIR}/.plugin/${FILE_NAME}
fi

UNZIP=0
if [[ ! -f ${README} ]]; then
  mkdir ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}
  unzip -p ${TRAVIS_BUILD_DIR}/.plugin/${FILE_NAME} ${PLUGIN_SLUG}/readme.txt >${README}
  ls -la ${README}
  UNZIP=1
fi

if [[ -n "${WP_VERSION}" && ${WP_VERSION} =~ ^[0-9]+\.[0-9]+$ && -z "${IGNORE_PLUGIN_VERSION}" ]]; then
  UPPER_CASE_SLUG=${PLUGIN_SLUG^^}
  IGNORE_EACH_PLUGIN_VERSION=$(eval echo '$'IGNORE_${UPPER_CASE_SLUG/-/_}_VERSION)
  if [[ -z "${IGNORE_EACH_PLUGIN_VERSION}" ]]; then
    REQUIRED_VERSION=$(cat ${README} | grep "Requires at least" | sed -e 's/Requires at least:\s*//')
    if [[ -n "${REQUIRED_VERSION}" ]]; then
      echo "Required version: ${REQUIRED_VERSION}"
      echo "WP version: ${WP_VERSION}"
      if [[ "${REQUIRED_VERSION}" != $(echo -e "${REQUIRED_VERSION}\n${WP_VERSION}" | sort -V | head -n1) ]]; then
        echo "Not enough version..."
        rm -rdf ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}
        UNZIP=0
      fi
    fi
  fi
fi

if [[ ${UNZIP} == 1 ]]; then
  rm -rdf ${TRAVIS_BUILD_DIR}/.plugin/${PLUGIN_SLUG}

  if type unar >/dev/null 2>&1; then
    unar ${TRAVIS_BUILD_DIR}/.plugin/${FILE_NAME} -o ${TRAVIS_BUILD_DIR}/.plugin
  else
    unzip ${TRAVIS_BUILD_DIR}/.plugin/${FILE_NAME} -d ${TRAVIS_BUILD_DIR}/.plugin
  fi
fi
