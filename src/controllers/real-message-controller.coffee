debug      = require('debug')('shadow-service:real-config-controller')
RealDevice = require '../models/real-device'

class RealMessageController
  create: (request, response) =>
    message = request.body
    debug 'realDevice: messageShadows', message
    realDevice = new RealDevice attributes: request.meshbluAuth.device, meshbluConfig: request.meshbluAuth
    realDevice.messageShadows {message}, (error) =>
      return @sendError {response, error} if error?
      debug "204: message success"
      response.sendStatus 204

  sendError: ({response,error}) =>
    debug "500: #{error.message}" unless error.code?
    return response.status(500).send error.message unless error.code?
    debug "#{error.code}: #{error.message}"
    return response.status(error.code).send error.message


module.exports = RealMessageController
