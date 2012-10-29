# Prefix CSS selectors.

Useful when loading say Twitter Bootstrap libraries for a widget on the page and we do not want to override the default style of that page.

## Requirements

- [parserlib](https://github.com/nzakas/parser-lib)

```bash
$ npm install -d
```

## Use

The library runs synchronously.

```coffee-script
prefix = require 'prefix-css-node'

css = """
body { background:pink }
a:after { content:"link", display:block }
"""

prefix.css css, 'bootstrap'
```

By default, `html` and `body` selectors are blacklisted, to change that or pass custom selectors to exclude, pass a list as the third parameter:

```coffee-script
prefix.css css, 'bootstrap', [ 'html', 'body', 'a', '#div' ]
```

### File IO

To input and output a file use the `cake` command:

```bash
$ cake --input in.css --output out.css --text gangnam prefix
```

## Testing

```bash
$ npm test
```