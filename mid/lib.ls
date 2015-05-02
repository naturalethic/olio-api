module.exports = (next) ->*
  for name, lib of olio.lib
    throw @error "Library clobbers existing property: #name" if @[name]
    @[name] ?= {}
    @[name].error = @error if @error
    if is-function lib
      @[name] = lib
    else
      for key, val of lib
        if is-function val
          throw @error "Library function clobbers existing property: #name:#key" if @[name][key]
          @[name][key] = val.bind @[name]
        else
          @[name][key] = val
  yield next
