global import require "prelude-ls"
require! {
  jade
  through
  livescript: "LiveScript"
  browserify: "browserify-middleware"
}

debug = not process.env.NODE_ENV? or process.env.NODE_ENV is "development"

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

live-script = compiler /\.ls/, (filename, src) ->
  return livescript.compile src, {filename, bare: true}

jade-lang = compiler /\.jade/, (filename, src) ->
  fn = jade.compile src, {
    filename
    client: true
    compileDebug: debug
    pretty: debug
  }
  return "var jade = require('jade/lib/runtime.js');
          module.exports=#{fn.to-string!}"

browserify.settings {
  transform: [
    live-script
    jade-lang
    "debowerify"
    "deamdify"
    "brfs"
  ]
  noParse: <[ jquery ]>
}

module.exports = exports = (root, app) ->
  app.get "/javascript/index.ls", browserify "#root/client/index.ls"

  return
