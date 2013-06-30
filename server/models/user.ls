require! {
  mongoose.model
  mongoose.Schema
  "../../common/user"
}

UserSchema = new Schema user

module.exports = exports = model "User", UserSchema
