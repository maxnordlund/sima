module.exports = exports =
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
