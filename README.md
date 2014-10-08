#grunt-sandbox-css [![Built with Grunt](https://cdn.gruntjs.com/builtwith.png)](http://gruntjs.com/)

[ ![Codeship Status for radekstepan/grunt-sandbox-css](https://www.codeship.io/projects/73860060-6f11-0130-b089-22000a9d02dd/status?branch=master)](https://www.codeship.io/projects/1944)

Say you are loading a Foundation/Bootstrap library for a widet and don't want them affecting the rest of the page. This [Grunt](http://gruntjs.com) plugin will prefix all selectors in input CSS file with your custom one.

##Quick start

Example `Gruntfile.coffee`:

```coffeescript
module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON "package.json"
        
        sandbox_css:
            foundation:
                files:
                  'build/foundation.sandboxed.css': 'src/foundation.css'
                options:
                    # E.g.: .row -> .foundation .row
                    prefix: '.foundation'
                    # Selectors where we do not prefix.
                    blacklist: [ 'html', 'body' ]

    grunt.loadNpmTasks('grunt-sandbox-css')

    grunt.registerTask('default', [ 'sandbox_css' ])
```