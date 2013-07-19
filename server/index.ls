global import require "prelude-ls"
require! {
  fs
  "express.io"
  "./browserify"
  "./styl"
  Q: q
  locals: "../package.json"
}

root = fs.realpathSync "#__dirname/.."

serve = (path, req, res) -->
  err, path <- fs.realpath "#root/components/#path"
  if err?
    res.send 500, err.stack
  else
    res.sendfile path

app = express!
app.http!io!

persons =
  * id: 1
    name: "Max Nordlund"
    email: "maxno@kth.se"
    role: "Admin"
  * id: 2
    name: "Martin Frost"
    email: "blame@kth.se"
    role: "Assistant"
  * id: 3
    name: "Johan Fogelström"
    email: "johfog@kth.se"
    role: "User"
  * id: 4
    name: "Oskar Segresvärd"
    email: "oskarseg@kth.se"
    role: "User"

locals import {
  persons
  roles: <[ admin assistant user ]>
  user: persons[2]
  courses:
    * code: "DD1341"
      name: "Introduktion till datalogi"
    * code: "DD1339"
      name: "Introduktion till datalogi"
  tasks:
    * id: 1
      user: persons[2]
      kind: "help"
      wait: "3:09"
      message: "Fattar inte sökträd"
      unimportant: true
    * id: 2
      user: persons[3]
      kind: "report"
      wait: "1:26"
      message: "Uppgift 10"
}

app.configure ->
  # Setup view Engine
  app.set "views", "#root/views"
  app.set "view engine", "jade"

  # Set the public folder as static assets
  app.use express.static "#root/public"
  browserify root, app

  app.get "/", (req, res) ->
    # res.set { "Content-Type": "application/xhtml+xml; charset=utf-8" }
    res.render "index", locals with title: "TaskIG"

  <[ Admin Courses Persons ]>.forEach (page) ->
    app.get "/#{page.toLowerCase!}", (req, res) ->
      # res.set { "Content-Type": "application/xhtml+xml; charset=utf-8" }
      res.render page.toLowerCase!, locals with title: "TaskIG | #page"

  app.get "/tasks/:course", (req, res) ->
    course = req.param "course"
    # res.set { "Content-Type": "application/xhtml+xml; charset=utf-8" }
    res.render "tasks", locals with title: "TaskIG | Tasks | #course"

  app.get "/style/normalize.css", serve "normalize-css/normalize.css"
  app.get "/javascript/html5shiv.js", serve "html5shiv/src/html5shiv.js"

app.configure "production", ->
  app.get "/style/:name", styl root, false

app.configure "development", ->
  Q.longStackSupport = true
  app.locals.pretty  = true

  app.get "/style/:name", styl root, true

  app.use (err, req, res, next) ->
    console.error err.stack
    res.send 500, err.stack
    # next err

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
