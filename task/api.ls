require! \koa
require! \koa-gzip
require! \koa-bodyparser

export watch = <[ host.ls olio.ls validation.ls api mid lib ]>

olio.config.api       ?= {}
olio.config.api.port  ?= 9001
olio.config.api.proxy ?= false

export api = ->*
  app = koa!
  app.use koa-gzip!
  app.use koa-bodyparser detectJSON: -> true
  app.proxy = olio.config.api.proxy
  mid = require-dir ...((glob.sync "#{process.cwd!}/node_modules/olio*/mid") ++ "#{process.cwd!}/mid")
  if olio.config.api.mid
    olio.config.api.mid |> each (m) ->
      info "Loading middleware: #m".green
      app.use mid[m]
  app.listen olio.config.api.port
  info "Started api server on port #{olio.config.api.port}".green
