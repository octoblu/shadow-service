debug      = require('debug')('shadow-service:real-config-controller')
RealDevice = require '../models/real-device'

class RealConfigController
  update: (request, response) =>
    debug 'realDevice: updateShadows'
    realDevice = new RealDevice attributes: request.body, meshbluConfig: request.meshbluAuth
    realDevice.updateShadows (error) =>
      return @sendError {response, error} if error?
      debug "204: update success"
      response.sendStatus 204

  sendError: ({response,error}) =>
    debug "500: #{error.message}" unless error.code?
    return response.status(500).send error.message unless error.code?
    debug "#{error.code}: #{error.message}"
    return response.status(error.code).send error.message

module.exports = RealConfigController
