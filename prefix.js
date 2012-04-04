(function() {
  var parserlib,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  parserlib = require("parserlib");

  exports.css = function(input, text, blacklist, log) {
    var line, lines, options, parser, shift;
    if (blacklist == null) blacklist = ['html', 'body'];
    if (log == null) log = true;
    text = "" + text + " ";
    lines = input.split("\n");
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
      var chars, part, s, selector, _i, _j, _len, _len2, _ref, _ref2, _ref3, _ref4, _results;
      _ref = event.selectors;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        selector = _ref[_i];
        if (log) {
          console.log("[" + selector.line + ":" + selector.col + "] \033[0;1m" + selector + "\033[0m");
        }
        if (log) {
          _ref2 = selector.parts;
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            part = _ref2[_j];
            if (_ref3 = (_ref4 = part.elementName) != null ? _ref4.text : void 0, __indexOf.call(blacklist, _ref3) >= 0) {
              console.log("  \033[0;31mblacklisted \033[0;1m" + part.elementName.text + "\033[0m");
            }
          }
        }
        s = (function() {
          var _k, _len3, _ref5, _ref6, _ref7, _results2;
          _ref5 = selector.parts;
          _results2 = [];
          for (_k = 0, _len3 = _ref5.length; _k < _len3; _k++) {
            part = _ref5[_k];
            if (_ref6 = (_ref7 = part.elementName) != null ? _ref7.text : void 0, __indexOf.call(blacklist, _ref6) >= 0) {
              _results2.push([selector.line, selector.col, part.elementName.text]);
            }
          }
          return _results2;
        })();
        if (!s.length) {
          if (selector.line === line) {
            shift += text.length;
          } else {
            shift = 0;
          }
          chars = lines[selector.line - 1].split('');
          chars.splice(selector.col - 1 + shift, 0, text);
          lines[selector.line - 1] = chars.join('');
          if (log) {
            console.log("  \033[0;34mreplaced \033[0;1m" + selector + "\033[0m");
          }
          _results.push(line = selector.line);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
    parser.parse(input);
    return lines.join("\n");
  };

}).call(this);
