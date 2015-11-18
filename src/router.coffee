ConfigController = require './controllers/config-controller'

class Router
  constructor: ({meshbluConfig}) ->
    @configController = new ConfigController meshbluConfig: meshbluConfig

  route: (app) =>
    app.post '/config/:id', @configController.update

module.exports = Router
