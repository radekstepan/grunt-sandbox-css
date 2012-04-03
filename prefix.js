(function() {
  var fs, parserlib,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  fs = require("fs");

  parserlib = require("parserlib");

  exports.css = function(input, output, text, blacklist) {
    var css, line, lines, options, parser, shift;
    if (blacklist == null) blacklist = ['html', 'body'];
    text = "" + text + " ";
    css = fs.readFileSync(input, "utf-8");
    lines = css.split("\n");
    options = {
      starHack: true,
      ieFilters: true,
      underscoreHack: true,
      strict: false
    };
    parser = new parserlib.css.Parser(options);
    line = 0;
    shift = 0;
    parser.addListener("startrule", function(event) {
      var chars, part, selector, skip, _i, _len, _ref, _results;
      _ref = event.selectors;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        selector = _ref[_i];
        skip = (function() {
          var _j, _len2, _ref2, _ref3, _ref4, _results2;
          _ref2 = selector.parts;
          _results2 = [];
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            part = _ref2[_j];
            if (_ref3 = (_ref4 = part.elementName) != null ? _ref4.text : void 0, __indexOf.call(blacklist, _ref3) >= 0) {
              _results2.push(part);
            }
          }
          return _results2;
        })();
        if (!skip.length) {
          if (selector.line === line) {
            shift += text.length;
          } else {
            shift = 0;
          }
          chars = lines[selector.line - 1].split('');
          chars.splice(selector.col - 1 + shift, 0, text);
          lines[selector.line - 1] = chars.join('');
          _results.push(line = selector.line);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
    parser.parse(css);
    return fs.open(output, 'w', 0666, function(e, id) {
      if (e) throw new Error(e);
      return fs.write(id, lines.join("\n", null, "utf8"));
    });
  };

}).call(this);
