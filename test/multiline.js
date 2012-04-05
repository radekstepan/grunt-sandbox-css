(function() {
  var input, prefix, should;

  should = require("should");

  prefix = require("../prefix");

  input = "/* a test CSS file */\nhtml { ; }\ndiv,\narticle { display:block; }\nbody.clazz { font-family:\"Helvetica;\"; }\ndiv.html,\na,\nhtml > div { text-decoration:underline; }";

  describe("Simple multi-line test", function() {
    describe("When run with no blacklist against a multi-line input CSS", function() {
      var result;
      result = prefix.css(input, '.bootstrap', []);
      return it("should replace all selectors", function() {
        var spec;
        spec = "/* a test CSS file */\n.bootstrap html { ; }\n.bootstrap div,\n.bootstrap article { display:block; }\n.bootstrap body.clazz { font-family:\"Helvetica;\"; }\n.bootstrap div.html,\n.bootstrap a,\n.bootstrap html > div { text-decoration:underline; }";
        return result.should.equal(spec);
      });
    });
    return describe("When run with a blacklist against a multi-line input CSS", function() {
      var result;
      result = prefix.css(input, '.bootstrap', ['html', 'body']);
      return it("should replace all not-blacklisted selectors and replace blacklisted with prefixing selector", function() {
        var spec;
        spec = "/* a test CSS file */\n.bootstrap { ; }\n.bootstrap div,\n.bootstrap article { display:block; }\n.bootstrap.clazz { font-family:\"Helvetica;\"; }\n.bootstrap div.html,\n.bootstrap a,\n.bootstrap > div { text-decoration:underline; }";
        return result.should.equal(spec);
      });
    });
  });

}).call(this);
