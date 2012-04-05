should = require "should"
prefix = require "../prefix"

# Multi-line CSS tests.

input =
"""
/* a test CSS file */
html { ; }
div,
article { display:block; }
body.clazz { font-family:"Helvetica;"; }
div.html,
a,
html > div { text-decoration:underline; }
"""

describe "Simple multi-line test", ->
  describe "When run with no blacklist against a multi-line input CSS", ->

    result = prefix.css input, '.bootstrap', []

    it "should replace all selectors", ->
        spec =
        """
        /* a test CSS file */
        .bootstrap html { ; }
        .bootstrap div,
        .bootstrap article { display:block; }
        .bootstrap body.clazz { font-family:"Helvetica;"; }
        .bootstrap div.html,
        .bootstrap a,
        .bootstrap html > div { text-decoration:underline; }
        """

        result.should.equal spec

  describe "When run with a blacklist against a multi-line input CSS", ->

    result = prefix.css input, '.bootstrap', [ 'html', 'body' ]

    it "should replace all not-blacklisted selectors and replace blacklisted with prefixing selector", ->
        spec =
        """
        /* a test CSS file */
        .bootstrap { ; }
        .bootstrap div,
        .bootstrap article { display:block; }
        .bootstrap.clazz { font-family:"Helvetica;"; }
        .bootstrap div.html,
        .bootstrap a,
        .bootstrap > div { text-decoration:underline; }
        """

        result.should.equal spec