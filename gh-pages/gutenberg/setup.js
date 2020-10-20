import './packages';

try {
	require( './plugin.js' );
} catch ( ex ) {
	// not load if not exists
}
