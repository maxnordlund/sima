import require "prelude-ls"
require! {
  jade
  through
  enchilada
  livescript: LiveScript
}

compiler = (regExp, compile, filename) -->
  return through! if not regExp.test filename
  src = ""
  write = (chunk) -> src += chunk
  end = ->
    var code
    try
      code = compile filename, src
    catch err
      @emit "error", err
    @queue code
    @queue null
  return through write, end

live = compiler /\.ls/, (filename, src) ->
  return livescript.compile src, {filename, bare: true}

jade = compiler /\.jade/, (filename, src) ->
  fn = jade.compile src, {filename, client: true}
  return "var jade = require('jade/lib/runtime.js');
          module.exports=#{fn.to-string!}"

defaults = {
  src: "#root/client"
  transforms: [ live, jade, "brfs", "debowerify", "deamdify" ]
  routes: {
    "/javascript/main.js": "./index.ls"
  },
}

module.exports = exports = (options) ->
  return enchilada defaults with options
