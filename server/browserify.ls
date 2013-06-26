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

module.exports = exports = (debug) ->
  live-script = compiler /\.ls/, (filename, src) ->
    return livescript.compile src, {filename, bare: true}

  jade-lang = compiler /\.jade/, (filename, src) ->
    fn = jade.compile src, {filename, client: true, compileDebug: debug, pretty: debug}
    return "var jade = require('jade/lib/runtime.js');
            module.exports=#{fn.to-string!}"
  options = {
    debug
    cache: not debug
    compress: not debug
    src: "#__dirname/../client/"
    transforms: [ live-script, jade-lang, "debowerify", "deamdify", "brfs" ]
    routes: {
      "/javascript/main.js": "./index.ls"
    },
  }
  return enchilada options
