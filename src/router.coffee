RealConfigController = require './controllers/real-config-controller'
VirtualConfigController = require './controllers/virtual-config-controller'

class Router
  constructor: () ->
    @realConfigController = new RealConfigController
    @virtualConfigController = new VirtualConfigController

  route: (app) =>
    app.post '/real/config', @realConfigController.update
    app.post '/virtual/config', @virtualConfigController.update

module.exports = Router
