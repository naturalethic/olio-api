require! \moment

module.exports = (next) ->*
  @log = (text) ->
    log = "#{moment!format 'YYYY-MM-DD HH:mm:ss'} INFOINFO"
    info
    if olio.config.api.resolve-session-id
      log += " [#{olio.config.api.resolve-session-id(this)}]"
    if olio.config.api.logip
      log += " (#{@ip})"
    info "#log #text".cyan
  yield next
