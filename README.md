# Scripts for Travis CI

[![CodeFactor](https://www.codefactor.io/repository/github/wp-content-framework/travis-ci/badge)](https://www.codefactor.io/repository/github/wp-content-framework/travis-ci)
[![License: GPL v2+](https://img.shields.io/badge/License-GPL%20v2%2B-blue.svg)](http://www.gnu.org/licenses/gpl-2.0.html)

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
  - Coveralls
- Deploy
  - GitHub releases
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
    "php-coveralls/php-coveralls": "^2.1",
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
      "phpmd ./src/,./configs/,./tests/ text phpmd.xml"
    ],
    "coveralls": [
      "php-coveralls -v"
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
    "cover": "jest --coverage",
    "coveralls": "cat ./coverage/lcov.info | coveralls"
  }
}
```
### 1. Prepare scripts
Download and run `prepare.sh` to create test configs.

_.travis.yml_
```yaml
before_script:
  - git clone --depth=1 https://github.com/wp-content-framework/travis-ci.git travis-ci
  - bash travis-ci/bin/prepare.sh
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
Set _COVERAGE_REPORT=1_ to run `composer coveralls`   

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
        - COVERAGE_REPORT=1
      script: bash tests/bin/php/wp-test.sh

    - stage: test
      language: node_js
      node_js: '11'
      dist: trusty
      env: COVERAGE_REPORT=1
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
-  GitHub release  
1. Go to [Personal access tokens](https://github.com/settings/tokens).
2. Generate token which has **repo** scope.
3. Set Environment Variables _GITHUB_TOKEN_ in the settings page

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
        api_key: ${GITHUB_TOKEN}
        draft: true
        overwrite: true
        on:
          tags: true
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
2. Set Environment Variables _SLACK_TOKEN_ in the settings page

or use `travis encrypt` command.

_.travis.yml_
```yaml
notifications:
  email: false
  slack: ${SLACK_TOKEN}
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
      - [ ] WP Directory
        - [ ] `SVN_USER`
        - [ ] `SVN_PASS`
  - [ ] Slack
    - [ ] `SLACK_TOKEN`
