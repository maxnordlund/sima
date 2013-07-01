module.exports = exports = (Schema) ->
  CourseSchema = new Schema
    _id: String # Course code
    name: String

  CourseSchema.virtual "code" .get -> @_id

  return CourseSchema
