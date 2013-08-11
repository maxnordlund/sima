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

persons = map (-> new schemas.User it),   require "../test/fixtures/persons.ls"
courses = map (-> new schemas.Course it), require "../test/fixtures/courses.ls"
new_task = (data, index) ->
  task = new schemas.Task data
  task.user = persons[index+1]
  return task
tasks = map new_task, require "../test/fixtures/tasks.ls"


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
