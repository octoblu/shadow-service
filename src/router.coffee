ShadowService = require './services/shadow-service'
RealConfigController = require './controllers/real-config-controller'
RealMessageController = require './controllers/real-message-controller'
VirtualConfigController = require './controllers/virtual-config-controller'

class Router
  constructor: () ->
    shadowService = new ShadowService
    @realConfigController = new RealConfigController {shadowService}
    @realMessageController = new RealMessageController {shadowService}
    @virtualConfigController = new VirtualConfigController {shadowService}

  route: (app) =>
    app.post '/real/config', @realConfigController.update
    app.post '/real/message', @realMessageController.create
    app.post '/virtual/config', @virtualConfigController.update

module.exports = Router
