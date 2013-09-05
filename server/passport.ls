require! {
  url
  passport
  request
}

export class CentralAuthenticationService extends passport.Strategy
  (options, @verify) ->
    import options{
      url, callback-url
    }
    @name = \cas

  absolute-url = (req, other-url) ->
    protocol = if req.connection.encrypted or req.headers["x-forwarded-proto"] is \https then \https else \http
    original = "#protocol://#{req.headers.host}#{req.url or ""}"
    url.resolve original, other-url

  authenticate: (req) ->
    if req.query?.ticket?
      # Ticket from CAS /login
      options = {
        url: url.resolve @url, \/validate
        method: \GET
        qs: {
          ticket: that
          service: absolute-url req, @callback-url
        }
      }
      request options, (err, response, body) ~>
        [ok, ugid] = lines body
        @verify ugid, (err, user, info) ~>
          @error err if err?
          @fail info if not user
          @success user, info
          @redirect req.session.return-to
    else
      # Not logged in yet
      base = url.parse @url
      base.query = {
        # +gateway # Doesn't work with KTH
        service: absolute-url req, @callback-url
      }
      delete! base.search
      @redirect url.format base

# module.exports = exports = CentralAuthenticationService
