files = [
	JASMINE,
	JASMINE_ADAPTER,
	'build/lib/bower_components/jquery/jquery.js',
	'build/lib/bower_components/underscore/underscore.js',
	'build/lib/bower_components/bootstrap/bootstrap.js',
	'build/js/vtex-message.js',
	'build/spec/helpers/jasmine-jquery.js',
	'build/spec/helpers/mock-ajax.js',
	{
		pattern: 'build/spec/fixtures/**/*.*',
		watched: true,
		included: false,
		served: true
	},
	'build/spec/*.js'
];
browsers = [
	'PhantomJS'
];