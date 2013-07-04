require! {
  mongoose.model
  mongoose.Schema
}

export {
  Course: model "Course", require("./schemas/Course") Schema
  Task:   model "Task",   require("./schemas/Task")   Schema
  User:   model "User",   require("./schemas/User")   Schema
}
