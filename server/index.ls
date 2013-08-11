global import require "prelude-ls"
global import require "../common"
require! {
  Q
  fs
  passport
  "connect-ensure-login".ensure-logged-in
  "express.io"
  "./styl"
  "./browserify"
  "../test/fixtures/persons"
  "../test/fixtures/courses"
  "../test/fixtures/tasks"
  locals: "../package.json"
  CentralAuthenticationService: "./passport"
}

root = fs.realpathSync "#__dirname/.."

app = express!
app.http!io!

locals import {
  tasks
  persons
  courses
  user: persons[2]
  roles: <[ admin assistant user ]>
}

app.configure ->
  # Setup view Engine
  app.set \views, "#root/views"
  app.set "view engine", \jade

  # Set the public folder as static assets
  app.use express.static "#root/public"

  # Passport
  options = {
    url: "https://login.kth.se/"
    callback-url: "/auth/callback"
  }
  passport.use new CentralAuthenticationService options, (ugid, done) ->
    # TODO: Find in Mongoose or do LDAP stuff to
    # get the rest of info and create a new User
    # done null, persons[ugid]
    done null, persons.0

  passport.serialize-user (user, done) ->
    done null, user.id
  passport.deserialize-user (id, done) ->
    done null, persons[id]
    # User.find-by-id id, done

  app.use express.bodyParser!
  app.use express.cookieParser!
  app.use express.session { secret: \secret-sauce }
  app.use passport.initialize!
  app.use passport.session!
  app.use app.router

  browserify root, app

  app.get "/login", passport.authenticate \cas
  app.get "/auth/callback", passport.authenticate \cas

  app.get "/", (req, res) ->
    # res.set { "Content-Type": "application/xhtml+xml; charset=utf-8" }
    res.render \index, locals with title: "TaskIG"

  app.get "/tasks/:course", (req, res) ->
    course = req.param \course
    # res.set { "Content-Type": "application/xhtml+xml; charset=utf-8" }
    res.render \tasks, locals with title: "TaskIG | Tasks | #course"

  get-page = (page) ->
    app.get "/#{page.toLowerCase!}", ensure-logged-in(\/login), (req, res) ->
      # res.set { "Content-Type": "application/xhtml+xml; charset=utf-8" }
      res.render page.toLowerCase!, locals with title: "TaskIG | #page"

  each get-page, <[ Admin Courses Persons ]>

  serve = (path, req, res) -->
    err, path <- fs.realpath "#root/components/#path"
    if err?
      res.send 500, err.stack
    else
      res.sendfile path

  app.get "/style/normalize.css", serve "normalize-css/normalize.css"
  app.get "/javascript/html5shiv.js", serve "html5shiv/src/html5shiv.js"

app.configure \production, ->
  app.get "/style/:name", styl root, false

app.configure \development, ->
  Q.longStackSupport = true
  app.locals.pretty  = true

  app.get "/style/:name", styl root, true

  app.use (err, req, res, next) ->
    console.log err.stack
    res.set { "Content-Type": "text/plain" }
    res.send 500, err.stack
    # next err

  # app.use require("express-error").express3 {
  #   contextLinesCount: 3
  #   handleUncaughtException: true
  # }

port = process.env.PORT or process.env.VMC_APP_PORT or 3000
app.listen port, ->
  console.log """
    Listening on #port in #{app.locals.settings.env} mode
    Press CTRL-C to stop server.
  """
