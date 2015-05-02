require! \http
require! \util

class ApiError extends Error
  (@code, @message) ~>
    if not @message and !is-number @code
      @message = @code
      @code = 500
    @name = \ApiError
    super @message
  to-string: -> @inspect!
  inspect: ->
    "#{@name}: [#{@code}] #{@message}"

module.exports = (next) ->*
  # Provide a helper method to create an object that contains the stack trace
  # Usage in apis:
  #   @error 404, 'Resource not found'
  @error = (code, message) -> throw ApiError code, message
  try
    yield next
  catch e
    code = parse-int((/^(\d{3})$/.exec e.code)?1)
    @response.status = code or 500
    # Assume 4xx errors are user driven and their message is safe as a response
    if code and code >= 400 and code < 500
      @response.body = e.message ?= http.STATUS_CODES[e.code.to-string!]
      error e.to-string!red
    else if code or !e.stack
      error e.to-string!red
    else
      error e.stack.red
