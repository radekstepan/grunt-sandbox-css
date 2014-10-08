should = require "should"
prefix = require "../tasks/lib.coffee"

input =
"""
div, article { display:block; }
@-webkit-keyframes progress-bar-stripes {
  from {
    background-position: 40px 0;
  }
  to {
    background-position: 0 0;
  }
}

@-moz-keyframes progress-bar-stripes {
  from {
    background-position: 40px 0;
  }
  to {
    background-position: 0 0;
  }
}

@-ms-keyframes progress-bar-stripes {
  from {
    background-position: 40px 0;
  }
  to {
    background-position: 0 0;
  }
}

@-o-keyframes progress-bar-stripes {
  from {
    background-position: 0 0;
  }
  to {
    background-position: 40px 0;
  }
}

@keyframes progress-bar-stripes {
  from {
    background-position: 40px 0;
  }
  to {
    background-position: 0 0;
  }
}
"""

expected =
"""
.bootstrap div, .bootstrap article {display:block;}
@-webkit-keyframes progress-bar-stripes {
  from {
    background-position: 40px 0;}
  to {
    background-position: 0 0;}}
@-moz-keyframes progress-bar-stripes {
  from {
    background-position: 40px 0;}
  to {
    background-position: 0 0;}}
@-o-keyframes progress-bar-stripes {
  from {
    background-position: 0 0;}
  to {
    background-position: 40px 0;}}
@keyframes progress-bar-stripes {
  from {
    background-position: 40px 0;}
  to {
    background-position: 0 0;}}
"""

# TODO: when parserlib is updated, put the ms stanza back in.

describe "when running on a file with key frame definitions", ->

  result = prefix.css input, '.bootstrap', []

  it "should preserve the keyframe info", ->

      result.should.equal expected
