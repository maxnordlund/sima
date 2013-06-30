require! {
  mongoose.model
  mongoose.Schema
  "./User"
  "../../common/task"
}

TaskSchema = new Schema task

module.exports = exports = model "Task", TaskSchema
