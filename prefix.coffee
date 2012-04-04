parserlib = require "parserlib"

exports.css = (input, text, blacklist=['html', 'body'], log=true) ->
    # Add a space after the prefix text.
    text = "#{text} "

    # Split on new lines.
    lines = input.split "\n"

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
            # Log.
            console.log "[" + selector.line + ":" + selector.col + "] \033[0;1m" + selector + "\033[0m" if log

            # Skip blacklisted selectors that cannot be prefixed.
            if log
                for part in selector.parts
                    if part.elementName?.text in blacklist
                        console.log "  \033[0;31mblacklisted \033[0;1m#{part.elementName.text}\033[0m"
            
            s = ([selector.line, selector.col, part.elementName.text] for part in selector.parts when part.elementName?.text in blacklist)
            if not s.length
                # The same line as before?
                if selector.line is line then shift += text.length else shift = 0

                chars = lines[selector.line - 1].split('')
                chars.splice(selector.col - 1 + shift, 0, text)
                lines[selector.line - 1] = chars.join('')

                console.log "  \033[0;34mreplaced \033[0;1m#{selector}\033[0m" if log

                # Update the line.
                line = selector.line

    # Parse.
    parser.parse input

    # Return on joined lines.
    lines.join "\n"