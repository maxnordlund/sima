require! {
  mongoose
  mongoose.Schema
}

export {
  Course: mongoose.model "Course", require("./schemas/Course") Schema
  Task:   mongoose.model "Task",   require("./schemas/Task") Schema
  User:   mongoose.model "User",   require("./schemas/User") Schema
}
