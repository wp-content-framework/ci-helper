const blockEditor = require( '@wordpress/block-editor' );
const blockLibrary = require( '@wordpress/block-library' );
const blocks = require( '@wordpress/blocks' );
const components = require( '@wordpress/components' );
const coreData = require( '@wordpress/core-data' );
const data = require( '@wordpress/data' );
const editPost = require( '@wordpress/edit-post' );
const editor = require( '@wordpress/editor' );
const element = require( '@wordpress/element' );
const hooks = require( '@wordpress/hooks' );
const i18n = require( '@wordpress/i18n' );
const plugins = require( '@wordpress/plugins' );
const richText = require( '@wordpress/rich-text' );
const url = require( '@wordpress/url' );
const lodash = require( 'lodash' );

window.wp = window.wp || {};
window.wp.blockEditor = window.wp.blockEditor || blockEditor;
window.wp.blockLibrary = window.wp.blockLibrary || blockLibrary;
window.wp.blocks = window.wp.blocks || blocks;
window.wp.components = window.wp.components || components;
window.wp.coreData = window.wp.coreData || coreData;
window.wp.data = window.wp.data || data;
window.wp.editPost = window.wp.editPost || editPost;
window.wp.editor = window.wp.editor || editor;
window.wp.element = window.wp.element || element;
window.wp.hooks = window.wp.hooks || hooks;
window.wp.i18n = window.wp.i18n || i18n;
window.wp.plugins = window.wp.plugins || plugins;
window.wp.richText = window.wp.richText || richText;
window.wp.url = window.wp.url || url;
window.lodash = window.lodash || lodash;

try {
	require( './plugin.js' );
} catch ( ex ) {
	// not load if not exists
}
