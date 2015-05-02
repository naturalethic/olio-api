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
  #   throw @error 404, 'Resource not found'
  @error = (code, message) -> throw ApiError code, message
  try
    yield next
  catch e
    code = parse-int((/^(\d{3})$/.exec e.code)?1)
    @response.status = code or 500
    # message = e.log or ((is-object e.message) and JSON.stringify(e.message)) or e.message.to-string!
    # Assume 4xx errors are user driven and their message is safe as a response
    if code and code >= 400 and code < 500
      @response.body = e.message ?= http.STATUS_CODES[e.code.to-string!]
      error e.to-string!red
      # if m = (/at Object\.out\$\.\w+.(\w+) \[as api\].*\/(\w+)\.ls/.exec (e.stack.split('\n') |> filter -> /\[as api\]/.test it))
      #   error "#{e.code} #{message} (#{m[2]}.#{m[1]})".red
      # else
      #   error "#{e.code} #{message}".red
    else if code
      error e.to-string!red
    else
      error e.stack.red
