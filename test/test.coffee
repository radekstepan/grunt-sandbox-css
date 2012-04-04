should = require "should"
prefix = require "../prefix"

input =
"""
/* a test CSS file */
html { ; }
div, article { display:block; }
body.clazz { font-family:"Helvetica;"; }
html > body, div.html, a, html > div { text-decoration:underline; }
"""

describe "Prefix should add a custom selector before CSS selectors", ->
  describe "When run with no blacklist against an input CSS", ->

    result = prefix.css input, '.bootstrap', [], false

    it "should replace all selectors and match the spec", ->
        spec =
        """
        /* a test CSS file */
        .bootstrap html { ; }
        .bootstrap div, .bootstrap article { display:block; }
        .bootstrap body.clazz { font-family:"Helvetica;"; }
        .bootstrap html > body, .bootstrap div.html, .bootstrap a, .bootstrap html > div { text-decoration:underline; }
        """

        result.should.equal spec