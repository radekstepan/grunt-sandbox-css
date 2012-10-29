fs = require 'fs'

prefix = require "./prefix"

option '-i', '--input [FILE]', 'input file'
option '-o', '--output [FILE]', 'output file'
option '-t', '--text [STRING]', 'a string to prefix with'

task 'prefix', 'prefix a .css file', (options) ->
    input  = options.input or throw new Error 'Need to specify an input file'
    output = options.output or input
    text   = options.text or throw new Error 'Need to specify the string to prefix with'

    input = fs.readFileSync input, "utf-8"

    write output, prefix.css input, text

write = (path, text, mode = "w") ->
    fs.open path, mode, 0o0666, (err, id) ->
        throw err if err
        fs.write id, text, null, "utf8"