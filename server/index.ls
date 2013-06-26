import require "prelude-ls"
require! {
  fs
  nib
  stylus
  "express.io"
  "./browserify"
  Q: q
  locals: "../package.json"
}

root  = "#__dirname/.."
style = (debug, req, res) -->
  filename = req.params.name.replace /\.css/, ""
  options  = {
    compress: not debug
    paths: [ "#root/style/", "#root/components/normalize-css", nib.path ]
  }

  Q.nfcall fs.realpath, "#root/style/#filename.styl"
  .then (path) ->
    filename := path
    return Q.nfcall fs.readFile, filename, { encoding: "utf-8" }
  .then (src) ->
    return Q.nfcall stylus.render, src, options with { filename }
  .done (css) ->
    res.set { "Content-Type": "text/css; charset=utf-8" }
    res.send 200, css

serve = (path, req, res) -->
  err, path <- fs.realpath "#root/components/#path"
  if err?
    res.send 500, err.stack
  else
    res.sendfile path

app = express!
app.http!io!

app.configure ->
  # Setup view Engine
  app.set "views", "#root/views"
  app.set "view engine", "jade"

  # Set the public folder as static assets
  app.use express.static "#root/public"

  app.get "/", (req, res) ->
    # res.set { "Content-Type": "application/xhtml+xml; charset=utf-8" }
    res.render "index", locals with title: "Sima"

  app.get "/style/normalize.css", serve "normalize-css/normalize.css"
  app.get "/javascript/html5shiv.js", serve "html5shiv/src/html5shiv.js"

  app.use (err, req, res, next) ->
    console.error err.stack
    # next err

app.configure "production", ->
  app.get "/style/:name", style false
  app.use browserify false

app.configure "development", ->
  Q.longStackSupport = true
  app.locals.pretty  = true

  app.get "/style/:name", style true
  app.use browserify true

  app.use require("express-error").express3 {
    contextLinesCount: 3
    handleUncaughtException: true
  }

port = process.env.PORT or process.env.VMC_APP_PORT or 3000
app.listen port, ->
  console.log """
    Listening on #port
    Mode is #{app.locals.settings.env}
    Press CTRL-C to stop server.
  """
