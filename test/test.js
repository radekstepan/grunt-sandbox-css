(function() {
  var input, prefix, should;

  should = require("should");

  prefix = require("../prefix");

  input = "/* a test CSS file */\nhtml { ; }\ndiv, article { display:block; }\nbody.clazz { font-family:\"Helvetica;\"; }\nhtml > body, div.html, a, html > div { text-decoration:underline; }";

  describe("Prefix should add a custom selector before CSS selectors", function() {
    return describe("When run with no blacklist against an input CSS", function() {
      var result;
      result = prefix.css(input, '.bootstrap', [], false);
      return it("should replace all selectors and match the spec", function() {
        var spec;
        spec = "/* a test CSS file */\n.bootstrap html { ; }\n.bootstrap div, .bootstrap article { display:block; }\n.bootstrap body.clazz { font-family:\"Helvetica;\"; }\n.bootstrap html > body, .bootstrap div.html, .bootstrap a, .bootstrap html > div { text-decoration:underline; }";
        return result.should.equal(spec);
      });
    });
  });

}).call(this);
