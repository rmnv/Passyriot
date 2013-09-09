'use strict'
module.exports = (grunt) ->

  grunt.initConfig

    banner: '/*! <%= grunt.template.today("yyyy-mm-dd, h:MM:ss TT") %> */\n'

    files:
      source: 'source'
      static: '_static'
      tmp:    '_tmp'

      assets:     '<%= files.static %>/assets'
      temporary:  '<%= files.assets %>/tmp'

      scripts:  '<%= files.source %>/scripts'
      styles:   '<%= files.source %>/styles'
      views:    '<%= files.source %>/views'



    # source/views/*.jade → _static/*.html
    jade:
      compile:
        options:
          pretty: true
          data:
            debug: true
        files: [
          expand: true
          cwd: '<%= files.views %>'
          src: ['**/*.jade']
          dest: '<%= files.static %>'
          ext: '.html'
        ]


    # source/scripts/*.coffee → _static/assets/*.js
    coffee:
      glob_to_miltiple:
        expand: true
        cwd: '<%= files.scripts %>'
        src: ['*.coffee']
        dest: '<%= files.assets %>/'
        ext: '.js'


    # source/styles/main.styl → _tmp/main.css
    stylus:
      compile:
        options:
          compress: false
          banner: '<%= banner %>'
        files:
          '<%= files.tmp %>/passyriot.css': '<%= files.styles %>/passyriot.styl'



    # -webkit-border-radius → border-radius
    autoprefixer:
      compile:
        options:
          browsers: ['last 2 version', '> 1%', 'ie 8', 'ie 7']
        files:
          '<%= files.assets %>/passyriot.css': '<%= files.tmp %>/passyriot.css'


    # Clean
    clean:
      styles: [ '<%= files.assets %>/*.css' ]
      views: [ '<%= files.static %>/*.html' ]
      scripts: [ '<%= files.assets %>/*.js' ]
      tmp: [ '<%= files.tmp %>' ]


    # Copy
    copy:
      scripts: # copy scripts to _static/assets
        files: [{expand: true, cwd: '<%= files.scripts %>', src: ['*.js'], dest: '<%= files.assets %>/'}]
      styles: # copy .css to public/assets
        files: [{expand: true, cwd: '<%= files.styles %>', src: ['*.css'], dest: '<%= files.assets %>/'}]


    # Server
    connect:
      server:
        port: 8000
        base: './_static'



    # Watch for changed files
    watch:

      stylus:
        files: ['<%= files.styles %>/*.styl']
        tasks: ['stylus', 'autoprefixer']
        options:
          livereload: false
      css:
        files: ['<%= files.assets %>/*.css']
        options:
          livereload: true
      coffee:
        files: ['<%= files.scripts %>/*.coffee']
        tasks: ['coffee']
        options:
          livereload: true
      jade:
        files: ['<%= files.views %>/**/*.jade']
        tasks: ['jade']
        options:
          livereload: true
      javascript:
        files: ['<%= files.scripts %>/*.js']
        tasks: ['copy:javascript']
        options:
          livereload: true





  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)


  grunt.registerTask 'build', [
    'clean'
    'jade'
    'coffee'
    'stylus'
    'autoprefixer'
    'copy'
  ]
  grunt.registerTask 'default', [
    'build'
    'connect'
    'watch'
  ]
