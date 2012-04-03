fs = require "fs"
parserlib = require "parserlib"

exports.css = (input, output, text, blacklist=['html', 'body']) ->
    # Add a space after the prefix text.
    text = "#{text} "

    # Read in file.
    css = fs.readFileSync(input, "utf-8")
    lines = css.split "\n"

    options =
        starHack: true
        ieFilters: true
        underscoreHack: true
        strict: false

    # Init parser.
    parser = new parserlib.css.Parser options

    line = 0
    shift = 0

    # Rule event.
    parser.addListener "startrule", (event) ->
        # Traverse all selectors.
        for selector in event.selectors
            # Skip blacklisted selectors that cannot be prefixed.
            skip = (part for part in selector.parts when part.elementName?.text in blacklist)
            if not skip.length
                # The same line as before?
                if selector.line is line then shift += text.length else shift = 0

                chars = lines[selector.line - 1].split('')
                chars.splice(selector.col - 1 + shift, 0, text)
                lines[selector.line - 1] = chars.join('')

                # Update the line.
                line = selector.line

    # Parse.
    parser.parse css

    # Write.
    fs.open output, 'w', 0666, (e, id) ->
        if e then throw new Error(e)
        fs.write id, lines.join "\n", null, "utf8"