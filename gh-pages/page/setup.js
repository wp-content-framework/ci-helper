const lodash = require( "lodash" );
window.lodash = window.lodash || lodash;

try {
	require( './plugin.js' );
} catch ( ex ) {
	// not load if not exists
}
