require! {
  mongoose.model
  mongoose.Schema
  "../../common/course"
}

CourseSchema = new Schema course
CourseSchema.virtual "code" .get -> @_id

module.exports = exports = model "Course", CourseSchema
