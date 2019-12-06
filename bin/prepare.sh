#!/usr/bin/env bash

set -e

current=$(
  cd $(dirname $0)
  pwd
)
source ${current}/variables.sh

echo ""
echo ">> Copy files."
files=()
files+=("phpmd.xml")
files+=("phpunit.xml")
for file in "${files[@]}"; do
  if [[ ! -f ${TRAVIS_BUILD_DIR}/${file} ]]; then
    echo ">>>> ${file}"
    cp ${SETTINGS_DIR}/${file} ${TRAVIS_BUILD_DIR}/${file}
  fi
done

if [[ ! -f ${TRAVIS_BUILD_DIR}/phpcs.xml ]]; then
  echo ">>>> phpcs.xml"
  sed -i -e 's/phpmd .\+\.xml/phpmd .\/src\/,.\/configs\/,.\/tests\/ text phpmd.xml/' ${TRAVIS_BUILD_DIR}/composer.json
  cp ${SETTINGS_DIR}/phpcs.xml ${TRAVIS_BUILD_DIR}/phpcs.xml
  if [[ ! -d ${TRAVIS_BUILD_DIR}/configs ]]; then
    sed -i -e '/\.\/configs\//d' ${TRAVIS_BUILD_DIR}/phpcs.xml
    sed -i -e 's/,\.\/configs\///' ${TRAVIS_BUILD_DIR}/composer.json
  fi
  if [[ ! -d ${TRAVIS_BUILD_DIR}/tests ]]; then
    sed -i -e '/\.\/tests\//d' ${TRAVIS_BUILD_DIR}/phpcs.xml
    sed -i -e 's/,\.\/tests\///' ${TRAVIS_BUILD_DIR}/composer.json
  fi
fi

files=()
files+=("bootstrap.php")
if [[ -d ${TRAVIS_BUILD_DIR}/tests ]]; then
  for file in "${files[@]}"; do
    echo ">>>> tests/${file}"
    rm -f ${TRAVIS_BUILD_DIR}/tests/${file}
    cp ${TESTS_DIR}/${file} ${TRAVIS_BUILD_DIR}/tests/${file}
  done
fi

if [[ -n "$(bash ${SCRIPT_DIR}/prepare/check-install.sh ${1-""})" ]]; then
  echo ""
  echo ">> Download plugins."
  mkdir -p ${TRAVIS_BUILD_DIR}/.plugin
  source ${SCRIPT_DIR}/plugins.sh

  for plugin in "${org_plugins[@]}"; do
    echo ">>>> ${plugin}"
    bash ${SCRIPT_DIR}/prepare/install-org-plugin.sh ${plugin}
  done

  for plugin in "${zip_plugins[@]}"; do
    echo ">>>> ${plugin}"
    bash ${SCRIPT_DIR}/prepare/install-zip-plugin.sh ${plugin}
  done

  find ${TRAVIS_BUILD_DIR}/.plugin -mindepth 2 -maxdepth 2 -type d -name .git | sed -e 's/\/\.git//' | xargs --no-run-if-empty basename | while read -r plugin; do
    if [[ ! "${github_plugins[*]} " == *"/${plugin} "* ]]; then
      rm -rdf ${TRAVIS_BUILD_DIR}/.plugin/${plugin}
    fi
  done
  if [[ ${#github_plugins[@]} -gt 0 ]]; then
    echo ""
    echo ">> Install latest node."
    source ${SCRIPT_DIR}/prepare/install-latest-node.sh

    if [[ ! -f ~/.ssh/config ]] || [[ -z $(grep <~/.ssh/config github) ]]; then
      echo ">> Write to ssh config."
      mkdir -p ~/.ssh
      echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >>~/.ssh/config
    fi
    for plugin in "${github_plugins[@]}"; do
      echo ">>>> ${plugin}"
      bash ${SCRIPT_DIR}/prepare/install-github-plugin.sh ${plugin}
    done
  fi
fi

if [[ -n "${CI}" ]]; then
  sed -i -e '/"php": "[\.0-9]\+"/d' ${TRAVIS_BUILD_DIR}/composer.json

  if [[ -n "${WP_VERSION}" && ${WP_VERSION} =~ ^[0-9]+\.[0-9]+$ ]]; then
    PHPUNIT7_VERSION=5.1
    PHPUNIT6_VERSION=4.8
    if [[ "${PHPUNIT7_VERSION}" != $(echo -e "${PHPUNIT7_VERSION}\n${WP_VERSION}" | sort -V | head -n1) ]]; then
      if [[ "${PHPUNIT6_VERSION}" != $(echo -e "${PHPUNIT6_VERSION}\n${WP_VERSION}" | sort -V | head -n1) ]]; then
        sed -i -e 's/"phpunit\/phpunit":[^,]\+\(,\?\)$/"phpunit\/phpunit": "^4.8 || ^5.7"\1/' ${TRAVIS_BUILD_DIR}/composer.json
      else
        sed -i -e 's/"phpunit\/phpunit":[^,]\+\(,\?\)$/"phpunit\/phpunit": "^4.8 || ^5.7 || ^6"\1/' ${TRAVIS_BUILD_DIR}/composer.json
      fi
    fi
  fi
fi
