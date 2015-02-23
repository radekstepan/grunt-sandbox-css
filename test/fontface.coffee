should = require "should"
prefix = require "../tasks/lib.coffee"

input =
"""
@font-face {
  font-family: MyFont;
  src: url("http:/foo.com/myfont.woff");
}
div, article { display:block; }
"""

expected =
"""
@font-face {
  font-family: MyFont;
  src: url("http:/foo.com/myfont.woff");}
.bootstrap div, .bootstrap article {display:block;}
"""

describe "when running on a file with font-face definitions", ->

  result = prefix.css input, '.bootstrap', []

  it "should preserve the fontface info", ->

      result.should.equal expected
