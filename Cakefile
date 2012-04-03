prefix = require "./prefix"

option '-i', '--input [FILE]', 'input file'
option '-o', '--output [FILE]', 'output file (optional)'
option '-p', '--prefix [TEXT]', 'prefix to prepend before every selector'

task "run", "prefix .css file selectors", (o) ->
    if (not o.input or not o.prefix) then throw new Error "Insufficient arguments"
    if not o.output then o.output = o.input

    prefix.css o.input, o.output, o.prefix