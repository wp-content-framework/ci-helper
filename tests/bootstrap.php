<?php
/**
 * PHPUnit bootstrap file
 *
 * @package Test_Travis
 */

$_tests_dir = getenv( 'WP_TESTS_DIR' );

if ( ! $_tests_dir ) {
	$_tests_dir = rtrim( sys_get_temp_dir(), '/\\' ) . '/wordpress-tests-lib';
}

if ( ! file_exists( $_tests_dir . '/includes/functions.php' ) ) {
	echo "Could not find $_tests_dir/includes/functions.php, have you run bin/install-wp-tests.sh ?" . PHP_EOL; // phpcs:ignore WordPress.Security.EscapeOutput.OutputNotEscaped
	exit( 1 );
}

// Give access to tests_add_filter() function.
require_once $_tests_dir . '/includes/functions.php';

/**
 * Manually load the plugin being tested.
 */
function _manually_load_plugin() {
	_activate_popular_plugins();

	$plugin_dir  = dirname( dirname( __FILE__ ) );
	$plugin_file = $plugin_dir . '/autoload.php';
	if ( ! is_readable( $plugin_file ) ) {
		$plugin_name = basename( $plugin_dir );
		$plugin_file = "{$plugin_dir}/{$plugin_name}.php";
	}

	/** @noinspection PhpIncludeInspection */
	require $plugin_file;

	$install = "{$plugin_dir}/install.php";
	if ( is_readable( $install ) ) {
		/** @noinspection PhpIncludeInspection */
		require $install;
	}
}

function _activate_popular_plugins() {
	foreach ( _get_plugin_dirs() as $dir ) {
		foreach ( _get_plugin_files( $dir ) as $file ) {
			echo "Activate plugin: {$file}\n";
			/** @noinspection PhpIncludeInspection */
			require $file;
		}
	}
}

function _get_plugin_dirs() {
	$plugins_dir = dirname( __FILE__ ) . '/.plugin';
	if ( getenv( 'ACTIVATE_POPULAR_PLUGINS' ) && is_dir( $plugins_dir ) ) {
		foreach ( scandir( $plugins_dir ) as $item ) {
			if ( substr( $item, 0, 1 ) == '.' ) {
				continue;
			}

			$path = "{$plugins_dir}/{$item}";
			if ( is_dir( $path ) ) {
				yield $path;
			}
		}
	}
}

function _get_plugin_files( $dir ) {
	foreach ( scandir( $dir ) as $item ) {
		if ( substr( $item, 0, 1 ) == '.' ) {
			continue;
		}

		$path = "{$dir}/{$item}";
		if ( is_file( $path ) && substr( $path, -4 ) === '.php' && _is_plugin_file( $path ) ) {
			yield $path;
		}
	}
}

function _is_plugin_file( $file ) {
	$fp        = fopen( $file, 'r' );
	$file_data = fread( $fp, 8192 );
	fclose( $fp );
	$file_data = str_replace( "\r", "\n", $file_data );

	return preg_match( '/^[ \t\/*#@]*Plugin Name:(.*)$/mi', $file_data, $match ) && ! empty( $match[1] );
}

tests_add_filter( 'muplugins_loaded', '_manually_load_plugin' );

// Start up the WP testing environment.
require $_tests_dir . '/includes/bootstrap.php';
