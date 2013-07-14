global import require "prelude-ls"
require! {
  fs
  nib
  stylus
  Q: "q"
}

module.exports = exports = (root, debug) ->
  options  = {
    compress: not debug
    paths: ["#root/style/", "#root/components/normalize-css", nib.path]
  }
  return (req, res) ->
    filename = req.param "name" .replace /\.css/, ""
    Q.nfcall fs.realpath, "#root/style/#filename.styl"
    .then (path) ->
      filename := path
      return Q.nfcall fs.readFile, filename, { encoding: "utf-8" }
    .then (src) ->
      return Q.nfcall stylus.render, src, options with { filename }
    .done (css) ->
      res.set { "Content-Type": "text/css; charset=utf-8" }
      res.send 200, css
