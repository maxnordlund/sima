module.exports = exports = (Schema) ->
  UserSchema = new Schema
    _id: String
    name: String
    email: String
    role:
      type: String
      default: "user"
      enum: <[ admin assistant user ]>

  return UserSchema
