module.exports = (next) ->*
  if is-array @api
    @api = first(@api |> filter -> is-function it)
  if is-array @in
    data = @in
    result = []
    for item in data
      @in = item
      result.push(yield @api!)
    @in = data
  else
    result = yield @api!
  result = 200 if result == undefined
  if is-number result
    @response.status = result
  else
    @body = result
