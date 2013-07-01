module.exports = exports = (Schema) ->
  TaskSchema = new Schema
    _id: String
    at: Date
    message: String
    kind:
      type: String
      default: "help"
      enum: <[ help report ]>
    user:
      type: String
      ref: "User"

  return TaskSchema
