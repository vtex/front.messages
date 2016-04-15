GruntVTEX = require 'grunt-vtex'

module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'

  config = GruntVTEX.generateConfig grunt, pkg,
    replaceGlob: "build/**/vtex-message.js"
    port: 9000

  # Add app files to coffe compilation and watch
  config.watch.coffee.files.push 'src/coffee/**/*.coffee'
  config.watch.main.files.push 'src/**/*.html'
  config.coffee.main.files[0].cwd = 'src/'
  config.coffee.main.files[0].dest = 'build/<%= relativePath %>/'

  config.uglify =
    options:
      banner: "/* #{pkg.name} - v#{pkg.version} */\n"
      sourceMap: true
    main:
      files:
        'dist/vtex-message.min.js': ['build/front-messages-ui/script/vtex-message.js']

  config.less.main.files[0].src = ['style.less', 'vtex-messages.less']

  config.coffee.test =
    expand: true
    cwd: 'spec/'
    src: ['**/*.coffee']
    dest: 'build/<%= relativePath %>/spec/'
    ext: '.js'

  config.cssmin =
    target:
      files: [
        expand: true,
        cwd: "build/front-messages-ui/style/"
        src: ['vtex-messages.css'],
        dest: 'dist/',
        ext: '.min.css'
      ]
      options:
        banner: "/* #{pkg.name} - v#{pkg.version} */\n"

  config.copy.test =
    expand: true
    cwd: 'spec/'
    src: ['**', '!**/*.coffee']
    dest: 'build/<%= relativePath %>/spec/'

  config.copy.dist =
    expand: true
    cwd: 'build//front-messages-ui/'
    src: ['script/vtex-message.js', 'style/vtex-message.css']
    flatten: true
    dest: 'dist/'

  config.copy.checkout =
    expand: true
    cwd: 'build//front-messages-ui/'
    src: ['script/vtex-message.js', 'style/vtex-message.css']
    flatten: true
    dest: '../vcs.checkout-ui/src/lib/front-messages-ui/'

  config.karma =
    options:
      configFile: 'karma.conf.js'
    unit:
      configFile: 'karma.conf.js',
      background: true
    deploy:
      singleRun: true

  config.watch.test =
    files: ['src/**/*.html', 'src/**/*.coffee', 'src/**/*.js', 'src/**/*.less', 'spec/**/*.*']
    tasks: ['dev', 'karma:unit:run']

  tasks =
  # Building block tasks
    build: ['clean', 'copy:main', 'copy:pkg', 'coffee', 'less']
    dev: ['clean', 'copy:main', 'copy:pkg', 'copy:test', 'coffee', 'less']
    min: ['uglify'] # minifies files
  # Deploy tasks
    dist: ['build', 'min', 'cssmin', 'copy:dist'] # Dist - minifies files
    checkout: ['build', 'min', 'cssmin', 'copy:dist', 'copy:checkout']
    test: ['dev', 'karma:unit', 'watch:test']
    vtex_deploy: ['shell:cp', 'shell:cp_br']
  # Development tasks
    default: ['build', 'connect', 'watch']
    devmin: ['build', 'min', 'connect:http:keepalive'] # Minifies files and serve
    tdd: ['dev', 'karma:unit', 'watch:test']

  # Project configuration.
  grunt.initConfig config
  grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-' and name isnt 'grunt-vtex'
  grunt.registerTask 'nolr', ->
    # Turn off LiveReload in development mode
    grunt.config 'watch.options.livereload', false
    return true
  grunt.registerTask taskName, taskArray for taskName, taskArray of tasks
