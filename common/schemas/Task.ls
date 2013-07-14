module.exports = exports = (Schema) ->
  TaskSchema = new Schema do
    _id: String
    at: Date
    message: String
    unimportant: Boolean
    kind:
      type: String
      default: "help"
      enum: <[ help report ]>
    user:
      type: String
      ref: "User"

  return TaskSchema
