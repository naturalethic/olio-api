require! \koa
require! \koa-gzip
require! \koa-bodyparser
require! \node-notifier

export watch = <[ host.ls olio.ls validation.ls api mid lib public/index.js ]>

olio.config.api       ?= {}
olio.config.api.name  ?= \Olio
olio.config.api.port  ?= 9001
olio.config.api.proxy ?= false

notify = (message) ->
  if olio.config.growl
    try
      nn = require 'node-notifier'
      nn.notify do
        title: 'Cops For Hire'
        message: message


export api = ->*
  app = koa!
  app.use (next) ->*
    if @method not in <[ GET PUT ]>
      @response.code = 405
      @response.body = 'Method not allowed'
      return
    yield next
  app.use koa-gzip!
  app.use koa-bodyparser detectJSON: -> it.request.method is \PUT
  app.proxy = olio.config.api.proxy
  mid = require-dir ...((glob.sync "#{process.cwd!}/node_modules/olio*/mid") ++ "#{process.cwd!}/mid")
  if olio.config.api.mid
    olio.config.api.mid |> each (m) ->
      info "Loading middleware: #m".green
      app.use mid[m]
  app.listen olio.config.api.port
  info "Started API on port #{olio.config.api.port}".green
  node-notifier.notify title: olio.config.api.name, message: "Started API on port #{olio.config.api.port}"
