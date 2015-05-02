require! \util

class ValidationError extends Error
  (@message) ~>
    @name = \ValidationError
    @code = 403
    super ...
  to-string: -> @inspect!
  inspect: ->
    ["#{@name}:"] ++ ((keys @message) |> map ~> "  #it: #{(values @message[it]).join(', ')}")
    |> join '\n'

module.exports = (next) ->*
  if is-array @api
    return if not definition = first(@api |> filter -> is-object it)
    throw ValidationError invalid if not empty(keys(invalid = yield @validate @in, definition))
  yield next
