module.exports = exports =
  _id: String
  name: String
  email: String
  role:
    type: String
    default: "user"
    enum: <[ admin assistant user ]>
