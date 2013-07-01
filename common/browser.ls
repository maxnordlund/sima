class Schema
  (@_definition) ->
    @_virtual = {}

  virtual: (name) ->
    obj = @_virtual
    for path in name.split "." then obj = obj[path] ?= {}
    return
      get: (getter) -> obj.get = getter
      set: (setter) -> obj.set = setter

model = (name, schema) ->
  class Model
    (@schema, input) -->
      src = input
      dst = this
      for key, def in @schema._definition
        switch typeof! def
          case "Object"
            # TODO: Add validation for enums, maybe refactor to use validate
            if (def.type? and def.type is typeof! src[key])
               or (def.default? and not src[key]?)
              dst[key] = src[key]
          case otherwise
            dst[key] = src[key] if def.name is typeof! src[key]

  Model.displayName = name
  return new Model schema

export {
  Course: model "Course", require("../schemas/Course") Schema
  Task:   model "Task",   require("../schemas/Task")   Schema
  User:   model "User",   require("../schemas/User")   Schema
}
