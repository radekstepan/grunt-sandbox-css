fs = require "fs"
prefix = require "./prefix"

option '-i', '--input [FILE]', 'input file'
option '-o', '--output [FILE]', 'output file (optional)'
option '-p', '--prefix [TEXT]', 'prefix to prepend before every selector'

task "run", "prefix .css file selectors", (o) ->
    if (not o.input or not o.prefix) then throw new Error "Insufficient arguments"
    if not o.output then o.output = o.input

    # Read in file & run.
    css = prefix.css fs.readFileSync(o.input, "utf-8"), o.prefix

    # Write the result.
    fs.open o.output, 'w', 0666, (e, id) ->
        if e then throw new Error(e)
        fs.write id, css, null, "utf8"