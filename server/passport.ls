require! \passport

class CentralAuthenticationService extends passport.Strategy
  (@verify) ->
    @name = \cas

  authenticate: (req) ->
    # TODO: send request to KTH:s CAS and receive answer.
    # Use session to remember which request goes to which response
    # Look at OAuth Strategy for example

module.exports = exports = new CentralAuthenticationService do
  (ugid, done) ->
    # TODO: Find in Mongoose or do LDAP stuff to
    # get the rest of info and create a new User
    done null, persons[ugid]
