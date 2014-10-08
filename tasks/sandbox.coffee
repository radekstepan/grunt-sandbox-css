fs     = require 'fs'
async  = require 'async'
colors = require 'colors'

lib = require './lib.coffee'

module.exports = (grunt) ->
  grunt.registerMultiTask 'sandbox_css', 'Sandbox a CSS library by prefixing its selectors', ->
    # Run in async.
    done = do @async

    # Wrapper for error logging, done callback expects a boolean.
    cb = (err) ->
      return do done unless err
      grunt.log.error (do err.toString).red
      done no

    pkg = grunt.config.data.pkg

    # For each input/output file.
    async.each @files, (file, cb) =>
      src  = do file.src.toString
      dest = do file.dest.toString
      opts = do @options or {}

      return cb 'No prefix specified' unless opts.prefix

      # File exists?
      fs.exists src, (exists) ->
        return cb "File #{src} does not exist" if !exists

        # Read it.
        fs.readFile src, 'utf8', (err, out) ->
          return cb err if err

          # Process it.
          out = lib.css out, opts.prefix, opts.blacklist

          # Write it.
          fs.writeFile dest, out, (err) ->
            return cb err if err

            grunt.log.ok "File #{dest} created."

            do cb
    , cb