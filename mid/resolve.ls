require! \moment
require! \inflection

api = require-dir \api

olio.config.api.log-ip ?= true

module.exports = (next) ->*
  # Camelize query parameters
  if typeof! @request.body == \Array
    @in = @request.body |> map ~> (pairs-to-obj (obj-to-pairs @query |> map ~> [(camelize it.0), it.1])) <<< it
  else
    @in = (pairs-to-obj (obj-to-pairs @query |> map -> [(camelize it.0), it.1])) <<< @request.body
  # Split the url into segments and determine the api function.
  # This destructuring looks complex, but it's purpose is to provide a convention for api naming within the module such that:
  # With an api file 'api/user.ls', these url to method lookups will follow:
  #   /user        => user.user
  #   /users       => user.users
  #   /user/create => user.create
  segments = filter id, @url.split('?').0.split('/')
  @api = (api[segments.0] and ((!segments.1 and api[segments.0][segments.0]) or api[segments.0][segments.1])) or (api[inflection.singularize segments.0] and api[inflection.singularize segments.0][segments.0])
  log = "#{moment!format 'YYYY-MM-DD HH:mm:ss'} "
  if @api
    log += "DISPATCH"
    color = \blue
  else
    log += "NOTFOUND"
    color = \yellow
  if olio.config.api.resolve-session-id
    log += " [#{olio.config.api.resolve-session-id(this)}]"
  if olio.config.api.logip
    log += " (#{@ip})"
  log += " #{@url.split('?').0}"
  info log[color]
  return if not @api
  yield next
