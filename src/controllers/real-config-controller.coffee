class RealConfigController
  constructor: ({@shadowService}) ->
  update: (request, response) =>
    realDeviceUuid = request.body.uuid
    meshbluConfig = request.meshbluAuth
    @shadowService.syncShadowDevices {realDeviceUuid, meshbluConfig}, (error) =>
      return @sendError {response, error} if error?
      response.sendStatus 204

  sendError: ({response,error}) =>
    response.status(error.code || 500).send error.message

module.exports = RealConfigController
