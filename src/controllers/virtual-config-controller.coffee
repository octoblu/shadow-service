class VirtualConfigController
  constructor: ({@shadowService}) ->
  update: (request, response) =>
    meshbluConfig     = request.meshbluAuth
    virtualDeviceUuid = request.body.uuid
    @shadowService.updateRealDevice {virtualDeviceUuid, meshbluConfig}, (error) =>
      return @sendError {response, error} if error?
      response.sendStatus 204

  sendError: ({response,error}) =>
    return response.status(error.code || 500).send error.message

module.exports = VirtualConfigController
