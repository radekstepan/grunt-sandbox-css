should = require "should"
prefix = require "../prefix"

input =
"""
html { ; }
div,
.foo bar.baz > quux #zump,
.foo.buzz cruz,
article {
  display:block;
  border: 1px solid gold;
}
body.clazz { font-family:"Helvetica;"; }
div.html,
a,
html > div { text-decoration:underline; }
"""

describe "Multi-line test", ->
  describe "when run with no blacklist against a multi-line input CSS", ->

    result = prefix.css input, '.bootstrap', []

    it "should replace all selectors", ->
        spec = [
          '.bootstrap html {}',
          '.bootstrap div,',
          '.bootstrap .foo bar.baz > quux #zump,',
          '.bootstrap .foo.buzz cruz,',
          '.bootstrap article {',
          '  display:block;',
          '  border: 1px solid gold;}',
          '.bootstrap body.clazz {font-family:"Helvetica;";}',
          '.bootstrap div.html,',
          '.bootstrap a,',
          '.bootstrap html > div {text-decoration:underline;}',
        ]

        result.should.equal spec.join('\n')

  describe "when run with a blacklist against a multi-line input CSS", ->

    result = prefix.css input, '.bootstrap', [ 'html', 'body', '.foo' ]

    it "should replace all not-blacklisted selectors and replace blacklisted with prefixing selector", ->
        spec =
        """
        .bootstrap {}
        .bootstrap div,
        .foo bar.baz > quux #zump,
        .foo.buzz cruz,
        .bootstrap article {
          display:block;
          border: 1px solid gold;}
        .bootstrap.clazz {font-family:"Helvetica;";}
        .bootstrap div.html,
        .bootstrap a,
        .bootstrap > div {text-decoration:underline;}
        """

        result.should.equal spec
