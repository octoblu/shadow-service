VirtualConfigController = require './controllers/virtual-config-controller'

class Router
  constructor: () ->
    @virtualConfigController = new VirtualConfigController

  route: (app) =>
    app.post '/virtual/config', @virtualConfigController.update

module.exports = Router
