ConfigController = require './controllers/config-controller'

class Router
  constructor: () ->
    @configController = new ConfigController

  route: (app) =>
    app.post '/config', @configController.update

module.exports = Router
