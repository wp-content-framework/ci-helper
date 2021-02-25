# Scripts for Travis CI

[![Update dependencies](https://github.com/wp-content-framework/ci-helper/workflows/Update%20dependencies/badge.svg)](https://github.com/wp-content-framework/ci-helper/actions?query=workflow%3A%22Update+dependencies%22)
[![CodeFactor](https://www.codefactor.io/repository/github/wp-content-framework/ci-helper/badge)](https://www.codefactor.io/repository/github/wp-content-framework/ci-helper)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/technote-space/jquery.marker-animation/blob/master/LICENSE)

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
<details>
<summary>Details</summary>

- [Overview](#overview)
- [Usage](#usage)
  - [0. Prepare `composer.json`, `package.json`](#0-prepare-composerjson-packagejson)
  - [1. Prepare scripts](#1-prepare-scripts)
  - [2. Use](#2-use)
  - [3. Slack](#3-slack)
- [Check List](#check-list)
- [Sample Plugins](#sample-plugins)

</details>
<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Overview
- Code check
  - PHP
    - PHP_CodeSniffer
    - PHPMD
  - JavaScript
    - ESLint
- Test
  - PHP
    - PHPUnit
  - JavaScript
    - Jest
- Coverage
  - Codecov
- Deploy
  - GitHub releases
  - GitHub pages
  - WP Directory

## Usage
### 0. Prepare `composer.json`, `package.json`
#### `composer.json`
- require-dev
```json
{
  "require-dev": {
    "squizlabs/php_codesniffer": "*",
    "wp-coding-standards/wpcs": "*",
    "phpmd/phpmd": "^2.6",
    "phpcompatibility/phpcompatibility-wp": "*",
    "dealerdirect/phpcodesniffer-composer-installer": "^0.5.0",
    "roave/security-advisories": "dev-master",
    "phake/phake": "^2.3 || ^3.1",
    "phpunit/phpunit": "^4.8 || ^5.7 || ^7.5"
  }
}
```
- scripts
```json
{
  "scripts": {
    "phpunit": [
      "phpunit"
    ],
    "phpcs": [
      "phpcs --standard=./phpcs.xml"
    ],
    "fix": [
      "phpcbf --standard=./phpcs.xml"
    ],
    "phpmd": [
      "phpmd ./src/,./configs/,./tests/ ansi phpmd.xml"
    ]
  }
}
```
#### `package.json`
- scripts
```json
{
  "scripts": {
    "lint": "eslint src/**/**/*.js && eslint __tests__/**/**/*.js",
    "cover": "jest --coverage"
  }
}
```
### 1. Prepare scripts
Download and run `prepare.sh` to create test configs.

_.travis.yml_
```yaml
before_script:
  - git clone --depth=1 https://github.com/wp-content-framework/ci-helper.git ci-helper
  - bash ci-helper/bin/prepare.sh
```
### 2. Use
#### Check coding style
_.travis.yml_
```yaml
jobs:
  fast_finish: true
  include:
    - stage: check
      language: php
      php: '7.2'
      script: bash tests/bin/php/phpcs.sh

    - stage: check
      language: php
      php: '7.2'
      script: bash tests/bin/php/phpmd.sh

    - stage: check
      language: node_js
      node_js: '11'
      dist: trusty
      script: bash tests/bin/js/js-lint.sh
```
#### Test

_.travis.yml_
```yaml
    - stage: test
      language: php
      php: '7.2'
      env: WP_VERSION=latest
      script: bash tests/bin/php/wp-test.sh

    - stage: test
      language: php
      php: '7.2'
      env:
        - WP_VERSION=5.2
        - WP_MULTISITE=1
      script: bash tests/bin/php/wp-test.sh

    - stage: test
      language: node_js
      node_js: '11'
      dist: trusty
      script: bash tests/bin/js/js-test.sh
```
#### SVN diff
_.travis.yml_
```yaml
    - stage: prepare
      language: node_js
      node_js: '11'
      dist: trusty
      script:
        - source tests/bin/deploy/env.sh
        - bash tests/bin/deploy/wp-check-diff.sh
```
#### Deploy
-  GitHub releases  
1. Go to [Personal access tokens](https://github.com/settings/tokens).
2. Generate token which has **repo** scope.
3. Run `travis encrypt` command to encrypt the token ([Details](https://docs.ci-helper.com/user/encryption-keys/)).  
like `travis encrypt "<GitHub Token>" --com -r <owner>/<repo>`

or use `travis setup releases` command.

_.travis.yml_
```yaml
    - stage: deploy
      language: node_js
      node_js: '11'
      dist: trusty
      script: skip
      before_deploy:
        - source tests/bin/deploy/env.sh
        - bash tests/bin/deploy/create.sh
      deploy:
        provider: releases
        skip_cleanup: true
        name: ${RELEASE_TITLE}
        tag_name: ${RELEASE_TAG}
        file: ${RELEASE_FILE}
        api_key:
          secure: <encrypted token>
        overwrite: true
        on:
          tags: true
```
- GitHub pages
1. Go to [Personal access tokens](https://github.com/settings/tokens).
2. Generate token which has **repo** scope and set as Environment Variables _GITHUB_TOKEN_ in the settings page.
3. Create script `bin/gh-pages/setup.sh`, `bin/gh-pages/pre_install.sh` or `bin/gh-pages/pre_setup.sh` to setup assets.

_.travis.yml_
```yaml
    - stage: deploy
      language: node_js
      node_js: '11'
      dist: trusty
      env:
        - GH_PAGES_PLUGIN_SCRIPT="./index.min.js"
        - GH_PAGES_PLUGIN_STYLE="./index.css"
        - GH_PAGES_TITLE="Test"
        - GH_PAGES_TEMPLATE=gutenberg
        - GH_PAGES_TRACKING_ID=UA-XXXXXXXX-X
      script: skip
      before_deploy:
        - source tests/bin/deploy/env.sh
        - bash tests/bin/deploy/gh-pages.sh
      deploy:
        provider: pages
        skip_cleanup: true
        github_token: ${GITHUB_TOKEN}
        keep_history: true
        local_dir: ${GH_PAGES_DIR}
        on:
          branch: master
```

- WP Directory
1. Set Environment Variables _SVN_USER_ and _SVN_PASS_ in the settings page

_.travis.yml_
```yaml
    - stage: deploy
      language: node_js
      node_js: '11'
      dist: trusty
      script: skip
      before_deploy:
        - source tests/bin/deploy/env.sh
      deploy:
        provider: script
        skip_cleanup: true
        script: bash tests/bin/deploy/wp-release.sh
        on:
          tags: true
```

### 3. Slack
1. Install Travis CI slack app and get `Token`.
2. Run `travis encrypt` command to encrypt the token.  
like `travis encrypt "<account>:<token>" --com -r <owner>/<repo>`

_.travis.yml_
```yaml
notifications:
  email: false
  slack:
    secure: <encrypted token>
```

## Check List
- [ ] composer.json
  - [ ] require
  - [ ] scripts
- [ ] package.json
  - [ ] scripts
- [ ] .travis.yml
  - [ ] before_script
  - [ ] jobs
    - [ ] Check coding style
    - [ ] Test
    - [ ] SVN diff
    - [ ] Deploy
      - [ ] GitHub release
        - [ ] `GITHUB_TOKEN`
      - [ ] GitHub pages
        - [ ] `GITHUB_TOKEN`
        - [ ] `bin/gh-pages/plugin.sh`
      - [ ] WP Directory
        - [ ] `SVN_USER`
        - [ ] `SVN_PASS`
  - [ ] Slack
    - [ ] `SLACK_TOKEN`

## Sample Plugins
[Test Travis](https://github.com/technote-space/test-travis)  
