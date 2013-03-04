#!/usr/bin/env coffee

parserlib = require "parserlib"

options =
    starHack: true
    ieFilters: true
    underscoreHack: true
    strict: false

combToText = (combinator) ->
  if combinator.text is ' ' then combinator.text else " #{ combinator } "

prefix = (pref, blacklist) -> (selector) ->
  output = []
  watchForFollowingElems = false
  hangoverCombinator = null
  for part, idx in selector.parts
    if part.elementName? and watchForFollowingElems and part.elementName.text in blacklist
      hangoverCombinator = null
    else if watchForFollowingElems and part instanceof parserlib.css.Combinator
      if part.type in ['descendant', 'child']
        hangoverCombinator = part
      else
        output.push part.text
        watchForFollowingElems = false
    else if idx > 0 # Only need to look at the first part.
      if hangoverCombinator?
        output.push combToText hangoverCombinator
        hangoverCombinator = null

      text = if part instanceof parserlib.css.Combinator
        combToText part
      else
        part.text
      output.push text
      watchForFollowingElems = false
    else
      {elementName, modifiers} = part
      if elementName?.text in blacklist
        re = new RegExp(elementName.text, 'g')
        output.push part.text.replace re, pref
        watchForFollowingElems = true
      else if (elementName is null) and (modifiers.length is 1) and (modifiers[0].text in blacklist)
        output.push part.text
      else
        output.push "#{ pref } #{ part }"
          
  output.join('')

exports.css = css = (input, text, blacklist=['html', 'body']) ->

    output = []

    # Init parser.
    parser = new parserlib.css.Parser options

    process = prefix text, blacklist

    ruleLine = 0
    lastLine = 1

    nlIfNeeded = (event) ->
      current = event.line
      newLine = current > lastLine
      output.push '\n' if newLine
      lastLine = current
      newLine

    closeBrace = (event) ->
      nlIfNeeded event
      output.push "}"

    parser.addListener 'charset', (event) ->
      lastLine = event.line
      output.push "@charset #{ event.charset };"

    parser.addListener 'namespace', (event) ->
      nlIfNeeded event
      output.push "@namespace #{ event.prefix } #{ event.uri };"

    parser.addListener 'import', (event) ->
      nlIfNeeded event
      output.push "@import #{ event.uri } #{ event.media.join(',') };"

    parser.addListener 'startfontface', ->
      nlIfNeeded event
      output.push "@fontface {"

    parser.addListener 'startpage', (event) ->
      nlIfNeeded event
      output.push "@page #{ event.pseudo ? '' } {"

    parser.addListener 'startpagemargin', (event) ->
      nlIfNeeded event
      output.push "@#{ event.margin } {"

    parser.addListener 'startmedia', (event) ->
      nlIfNeeded event
      output.push "@media #{ event.media.join(',') } {"

    parser.addListener 'startkeyframes', (event) ->
      nlIfNeeded event
      output.push "@#{ event.prefix }keyframes #{ event.name } {"

    parser.addListener 'startrule', (event) ->
      nlIfNeeded event
      selectors = event.selectors.slice()
      prefixed = selectors.map process
      startLine = selectors[0].line
      lastLine = ruleLine = selectors[selectors.length - 1].line
      delim = if startLine is ruleLine then ' ' else '\n'
      output.push prefixed.join(',' + delim)
      output.push ' {'

    parser.addListener 'endmedia', closeBrace
    parser.addListener 'endkeyframes', closeBrace
    parser.addListener 'endpagemargin', closeBrace
    parser.addListener 'endpage', closeBrace
    parser.addListener 'endfontface', closeBrace
    parser.addListener 'endrule', closeBrace

    parser.addListener 'property', (event) ->
      onNewLine = nlIfNeeded event
      {property, value, important} = event
      offset = property.col
      indent = if onNewLine then new Array(offset).join(' ') else ''
      importance = if important then '!important' else ''
      delim = if offset + property.text.length + 1 is value.col then '' else ' '
      output.push "#{indent}#{ event.property }:#{ delim }#{ event.value }#{ importance };"

    # Parse.
    parser.parse input

    output.join ''

# Produce a function with its prefix and blacklist preset.
exports.prefixer = (text, blacklist) -> (input) -> css input, text, blacklist
