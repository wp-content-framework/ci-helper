const SpeedMeasurePlugin = require( 'speed-measure-webpack-plugin' );
const smp = new SpeedMeasurePlugin();
const webpack = require( 'webpack' );
const pkg = require( './package' );

const banner = `${ pkg.name }-editor ${ pkg.version }\nCopyright (c) ${ new Date().getFullYear() } ${ pkg.author }\nLicense: ${ pkg.license }`;

const webpackConfig = {
	context: __dirname,
	entry: './editor.js',
	output: {
		path: __dirname,
		filename: 'editor.min.js',
	},
	module: {
		rules: [
			{
				test: /\.js$/,
				exclude: /node_modules/,
				loader: 'babel-loader',
			},
			{
				test: /\.(sa|sc|c)ss$/,
				use: [ 'style-loader', 'css-loader', 'sass-loader' ],
			},
		],
	},
	plugins: [
		new webpack.BannerPlugin( banner ),
	],
};

module.exports = smp.wrap( webpackConfig );
