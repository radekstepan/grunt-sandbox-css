should = require "should"
prefix = require "../prefix"

describe "Multiple selector part replace", ->
  describe "when run with blacklist > blacklist selector (without a dot in selector)", ->

    result = prefix.css 'html > body { ; }', 'bootstrap'

    it "should replace the whole selector with the prefix", ->
        result.should.equal 'bootstrap {}'

  describe "when run with blacklist > blacklist selector (with a dot in selector)", ->

    result = prefix.css 'html > body { ; }', '.bootstrap'

    it "should replace the whole selector with the prefix", ->
        result.should.equal '.bootstrap {}'
