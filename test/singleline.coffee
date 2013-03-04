should = require "should"
prefix = require "../prefix"

input =
"""
/* a test CSS file */
html { ; }
div, article { display:block; }
body.clazz { font-family:"Helvetica;"; }
div.html, a, html > div { text-decoration:underline; }
"""

describe "Single-line test", ->
  describe "when run with no blacklist against a single-line input CSS", ->

    result = prefix.css input, '.bootstrap', []

    it "should replace all selectors", ->
        spec =
        """
        /* a test CSS file */
        .bootstrap html { ; }
        .bootstrap div, .bootstrap article { display:block; }
        .bootstrap body.clazz { font-family:"Helvetica;"; }
        .bootstrap div.html, .bootstrap a, .bootstrap html > div { text-decoration:underline; }
        """

        result.should.equal spec

  describe "when run with a blacklist against a single-line input CSS", ->

    result = prefix.css input, '.bootstrap', [ 'html', 'body' ]

    it "should replace all not-blacklisted selectors and replace blacklisted with prefixing selector", ->
        spec =
        """
        /* a test CSS file */
        .bootstrap { ; }
        .bootstrap div, .bootstrap article { display:block; }
        .bootstrap.clazz { font-family:"Helvetica;"; }
        .bootstrap div.html, .bootstrap a, .bootstrap > div { text-decoration:underline; }
        """

        result.should.equal spec

  describe "when using a processor", ->

    processor = prefix.prefixer '.bootstrap', [ 'html', 'body' ]
    result = processor input

    it "should replace all not-blacklisted selectors and replace blacklisted with prefixing selector", ->
        spec =
        """
        /* a test CSS file */
        .bootstrap { ; }
        .bootstrap div, .bootstrap article { display:block; }
        .bootstrap.clazz { font-family:"Helvetica;"; }
        .bootstrap div.html, .bootstrap a, .bootstrap > div { text-decoration:underline; }
        """

        result.should.equal spec
