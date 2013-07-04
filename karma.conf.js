files = [
	JASMINE,
	JASMINE_ADAPTER,
	'build/lib/jquery-1.8.3.min.js',
	'build/lib/underscore-min.js',
	'build/lib/bootstrap/js/bootstrap.min.js',
	'build/js/vtex-message.js',
	'build/spec/helpers/jasmine-jquery.js',
	{
		pattern: 'build/spec/fixtures/**/*.html',
		watched: true,
		included: false,
		served: true
	},
	'build/spec/*.js'
];
browsers = [
	'PhantomJS'
];