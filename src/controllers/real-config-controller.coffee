class RealConfigController
  constructor: ({@shadowService}) ->
  update: (request, response) =>
    attributes = request.meshbluAuth.device
    meshbluConfig = request.meshbluAuth
    @shadowService.updateShadows {attributes, meshbluConfig}, (error) =>
      return @sendError {response, error} if error?
      response.sendStatus 204

  sendError: ({response,error}) =>
    response.status(error.code || 500).send error.message

module.exports = RealConfigController
