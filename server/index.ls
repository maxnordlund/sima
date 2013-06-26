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

root = "#{__dirname}/.."
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

app.configure "production", ->
  app.get "/style/:name", style {
    compress: true
  }

  # Set up middleware
  app.use browserify {
    cache: true
    compress: true
    debug: false
  }

app.configure "development", ->
  Q.longStackSupport = true
  app.locals.pretty  = true

  app.get "/style/:name", style {
    compress: false
  }
  # Set up middleware
  app.use browserify {
    cache: false
    compress: false
    debug: true
  }
  app.use require("express-error").express3 {
    contextLinesCount: 3
    handleUncaughtException: true
  }

style = (options, req, res) -->
  filename = req.params.name.replace /\.css/, ""
  Q.nfcall fs.realpath, "#root/style/#filename.styl"
  .then (path) ->
    filename := path
    return Q.nfcall fs.readFile, filename, { encoding: "utf-8" }
  .then (src) ->
    return Q.nfcall stylus.render, src, options with {
      filename
      paths: [ "#root/style/", nib.path ]
    }
  .done (css) ->
    res.set { "Content-Type": "text/css; charset=utf-8" }
    res.send 200, css

port = process.env.PORT or process.env.VMC_APP_PORT or 3000
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."
