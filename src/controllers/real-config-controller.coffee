RealDevice = require '../models/real-device'

class RealConfigController
  update: (request, response) =>
    realDevice = new RealDevice attributes: request.body, meshbluConfig: request.meshbluAuth
    realDevice.updateShadows (error) =>
      return @sendError {response, error} if error?
      response.sendStatus 204

  sendError: ({response,error}) =>
    return response.status(500).send error.message unless error.code?
    return response.status(error.code).send error.message

module.exports = RealConfigController
