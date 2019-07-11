#!/usr/bin/env bash

## @link https://isabelcastillo.com/plugins-active-installs

set -e

org_plugins=()
org_plugins+=( "wordpress-seo" )
org_plugins+=( "akismet" )
org_plugins+=( "contact-form-7" )
org_plugins+=( "jetpack" )
org_plugins+=( "woocommerce" )
org_plugins+=( "wordpress-importer" )
org_plugins+=( "duplicate-post" )
org_plugins+=( "wordfence" )
org_plugins+=( "google-sitemap-generator" )
org_plugins+=( "cookie-notice" )
org_plugins+=( "wp-multibyte-patch" )
org_plugins+=( "advanced-custom-fields" )
org_plugins+=( "custom-post-type-ui" )
org_plugins+=( "autoptimize" )

github_plugins=()
github_plugins+=( "wp-content-framework/0-framework-test" )

zip_plugins=()
#zip_plugins+=( "https://sitekit.withgoogle.com/service/download/google-site-kit.zip" )

if [[ -n "${TRAVIS_BUILD_DIR}" && -f ${TRAVIS_BUILD_DIR}/tests/bin/plugins.sh ]]; then
    source ${TRAVIS_BUILD_DIR}/tests/bin/plugins.sh
fi
