require! \moment

module.exports = (next) ->*
  @log = (text, type = 'INFOINFO', color = 'cyan') ->
    log = "#{moment!format 'YYYY-MM-DD HH:mm:ss'} #type"
    if olio.config.api.resolve-session-id
      log += " [#{olio.config.api.resolve-session-id(this)}]"
    if olio.config.api.logip
      log += " (#{@ip})"
    info "#log #text"[color]
  yield next
