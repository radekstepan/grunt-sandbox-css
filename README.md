# Prefix CSS selectors in a file.

## Requirements

You can install all the dependencies by running `npm install -d`.

- [parserlib](https://github.com/nzakas/parser-lib)
- [CoffeeScript](http://coffeescript.org/) if you want to run from CLI.

## Run

You can use the CoffeeScript CLI and run:

`cake --input "test.css" --prefix ".bootstrap" run`

## Mocha Testing

`npm install -d ; coffee --compile test/ ; mocha --ui bdd --reporter spec`