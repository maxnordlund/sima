global import require "prelude-ls/lib/index.js"
$ = jQuery = require "jquery"

views =
  admin:   require "../views/admin/admin.jade"
  courses:
    index: require "../views/courses/list.jade"
    item:  require "../views/courses/course.jade"
  persons:
    index: require "../views/persons/list.jade"
    item:  require "../views/persons/person.jade"
  tasks:
    index: require "../views/tasks/list.jade"
    item:  require "../views/tasks/task.jade"

schemas = require "../common"

persons = map (-> new schemas.User it), [
  * _id: "1"
    name: "Max Nordlund"
    email: "maxno@kth.se"
    role: "Admin"
  * _id: "2"
    name: "Martin Frost"
    email: "blame@kth.se"
    role: "Assistant"
  * _id: "3"
    name: "Johan Fogelström"
    email: "johfog@kth.se"
    role: "User"
  * _id: "4"
    name: "Oskar Segresvärd"
    email: "oskarseg@kth.se"
    role: "User"
]

courses = map (-> new schemas.Course it), [
  * _id: "DD1341"
    name: "Introduktion till datalogi"
  * _id: "DD1339"
    name: "Introduktion till datalogi"
]

tasks = map (-> new schemas.Task it), [
  * _id: "1"
    user: persons[2]
    kind: "help"
    at: new Date
    message: "Fattar inte sökträd"
    unimportant: true
  * _id: "2"
    user: courses[3]
    kind: "report"
    at: new Date
    message: "Uppgift 10"
]

locals = {
  tasks
  persons
  courses
  user: persons[2]
  roles: <[ admin assistant user ]>
}

window import schemas
window.locals = locals

walker = ->
  console.log it.displayName
  it.validate (errs) -> console.log Object.keys(errs)

for docs in <[ persons courses tasks ]>
  each walker, locals[docs]
