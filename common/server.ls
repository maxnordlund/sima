require! {
  Q
  ldapjs
  mongoose
  mongoose.Schema
}

dn = "ou=Addressbook,dc=kth,dc=se"
ldap = ldapjs.create-client do
  url: "ldap://127.0.0.1:9999"
  # url: "ldap://ldap.kth.se:389"
  sizeLimit: 1

search = (ugid) ->
  deferred = Q.defer!
  opts =
    scope: \sub
    filter: new ldapjs.EqualityFilter do
      attribute: \ugKthid
      value: ugid
  ldap.search dn, opts, (err, res) ->
    return deferred.reject err if err?
    res.on \error, deferred.reject
    res.on \searchEntry, (entry) -> deferred.resolve entry.object
  return deferred.promise

UserSchema = require("./schemas/User") Schema
UserSchema.statics.find-by-ugid = (ugid, cb) ->
  console.log @find-by-id ugid
  return Q @find-by-id ugid
  .then ->
    console.log \Success, it
    return it
  .fail (err) ~>
    console.log err
    return search ugid
    .then (res) ->
      obj = {
        _id: ugid
        name: res.display-name
        email: res.mail
      }
      console.log \search, res
      return Q.ninvoke @, \create, obj
  .nodeify cb

export {
  Course: mongoose.model "Course", require("./schemas/Course") Schema
  Task:   mongoose.model "Task",   require("./schemas/Task") Schema
  User:   mongoose.model "User",   UserSchema
}
