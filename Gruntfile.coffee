GruntVTEX = require 'grunt-vtex'

module.exports = (grunt) ->
	pkg = grunt.file.readJSON 'package.json'

	config = GruntVTEX.generateConfig grunt, pkg,
		replaceGlob: "build/**/vtex-message.js"

	# Add app files to coffe compilation and watch
	config.watch.coffee.files.push 'src/coffee/**/*.coffee'
	config.watch.main.files.push 'src/**/*.html'
	config.coffee.main.files[0].cwd = 'src/'
	config.coffee.main.files[0].dest = 'build/<%= relativePath %>/'

	tasks =
	# Building block tasks
		build: ['clean', 'copy:main', 'copy:pkg', 'coffee', 'less']
	# Deploy tasks
		dist: ['build', 'copy:deploy'] # Dist - minifies files
		test: []
		vtex_deploy: ['shell:cp', 'shell:cp_br']
	# Development tasks
		dev: ['nolr', 'build', 'watch']
		default: ['build', 'connect', 'watch']
		devmin: ['build', 'min', 'connect:http:keepalive'] # Minifies files and serve

	# Project configuration.
	grunt.initConfig config
	grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-' and name isnt 'grunt-vtex'
	grunt.registerTask 'nolr', ->
		# Turn off LiveReload in development mode
		grunt.config 'watch.options.livereload', false
		return true
	grunt.registerTask taskName, taskArray for taskName, taskArray of tasks