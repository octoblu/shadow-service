RealConfigController = require './controllers/real-config-controller'
RealMessageController = require './controllers/real-message-controller'
VirtualConfigController = require './controllers/virtual-config-controller'

class Router
  constructor: () ->
    @realConfigController = new RealConfigController
    @realMessageController = new RealMessageController
    @virtualConfigController = new VirtualConfigController

  route: (app) =>
    app.post '/real/config', @realConfigController.update
    app.post '/real/message', @realMessageController.create
    app.post '/virtual/config', @virtualConfigController.update

module.exports = Router
