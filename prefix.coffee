#!/usr/bin/env coffee

parserlib = require "parserlib"

exports.css = css = (input, text, blacklist=['html', 'body']) ->
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
                    p = part.col - 1 + shift

                    # Replace the selector with our own.
                    if p
                        # In the middle of the line?
                        line = line[0..p - 1].concat line[p..].join('').replace(new RegExp(el), text).split('')
                    else
                        line = line.join('').replace(new RegExp(el), text).split('')

            # Prefix with custom text.
            if not blacklisted
                line.splice(position + shift, 0, text + ' ')
                # Move the line shift.
                shift += text.length + 1
            
            # Join up.
            line = line.join('')

            # Check for `prefix` > `prefix` rules having replace 2 blacklisted rules.
            line = line.replace(new RegExp(text + " *\> *" + text), text)

            # Save the line back.
            lines[selector.line - 1] = line

            # Update the line.
            index = selector.line

    # Parse.
    parser.parse input

    # Return on joined lines.
    lines.join "\n"

# Produce a function with its prefix and blacklist preset.
exports.prefixer = (text, blacklist) -> (input) -> css input, text, blacklist
