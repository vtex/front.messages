//files = [
//	JASMINE,
//	JASMINE_ADAPTER,
//	'build/lib/bower_components/jquery/jquery.js',
//	'build/lib/bower_components/underscore/underscore.js',
//	'build/lib/bower_components/bootstrap/bootstrap.js',
//	'build/js/vtex-message.js',
//	'build/spec/helpers/jasmine-jquery.js',
//	'build/spec/helpers/mock-ajax.js',
//	{
//		pattern: 'build/spec/fixtures/**/*.*',
//		watched: true,
//		included: false,
//		served: true
//	},
//	'build/spec/*.js'
//];


module.exports = function(config) {
	config.set({
		basePath: '',
		frameworks: ['jasmine'],
		browsers: [ 'PhantomJS'],
		port: 9876,
		autoWatch: false,
		files: [
			'build/front-messages-ui/lib/bower_components/jquery/jquery.js',
			'build/front-messages-ui/lib/bower_components/underscore/underscore.js',
			'build/front-messages-ui/lib/bower_components/bootstrap/bootstrap.js',
			'build/front-messages-ui/script/vtex-message.js',
			'build/front-messages-ui/spec/helpers/jasmine-jquery.js',
			'build/front-messages-ui/spec/helpers/mock-ajax.js',
			{
				pattern: 'build/front-messages-ui/spec/fixtures/**/*.*',
				watched: true,
				included: false,
				served: true
			},
			'build/front-messages-ui/spec/*.js'
		]
	});
};