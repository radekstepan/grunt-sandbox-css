parserlib = require "parserlib"

exports.css = (input, text, blacklist=['html', 'body']) ->
    log '------------------------------'

    # Split on new lines.
    lines = input.split "\n"

    options =
        starHack: true
        ieFilters: true
        underscoreHack: true
        strict: false

    # Init parser.
    parser = new parserlib.css.Parser options

    index = 0
    shift = 0

    # Rule event.
    parser.addListener "startrule", (event) ->
        # Traverse all selectors.
        for selector in event.selectors
            log selector
            
            # Where are we? Be 0 indexed.
            position = selector.col - 1

            # Make a char[] line.
            line = lines[selector.line - 1].split('')

            # Reset line shift if this is a new line.
            if selector.line isnt index then shift = 0

            # Find blacklisted selectors.
            blacklisted = false
            for part in selector.parts
                if part.elementName?.text in blacklist
                    blacklisted = true
                    el = part.elementName.text
                    # Replace the selector with our own.
                    log [ "  before", line.join('') ], "32"
                    line = line[part.col - 1 + shift..].join('').replace(new RegExp(el), text).split('')
                    log [ "  after ", line.join('') ], "31"

            # Prefix with custom text.
            if not blacklisted
                log [ "  before", line.join('') ], "32"
                line.splice(position + shift, 0, text + ' ')
                log [ "  after ", line.join('') ], "31"
                # Move the line shift.
                shift += text.length + 1
            
            # Save the line back.
            lines[selector.line - 1] = line.join('')

            # Update the line.
            index = selector.line

    # Parse.
    parser.parse input

    # Return on joined lines.
    lines.join "\n"

# Console logging function.
log = (text, color="1") ->
    if text instanceof Array then text = text.join(' | ')
    console.log "\033[0;#{color}m#{text}\033[0m"