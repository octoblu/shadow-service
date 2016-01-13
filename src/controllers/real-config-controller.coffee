debug         = require('debug')('shadow-service:real-config-controller')
RealDevice    = require '../models/real-device'
ShadowService = require '../services/shadow-service'

class RealConfigController
  constructor: ({@shadowService}) ->
  update: (request, response) =>
    debug 'realDevice: updateShadows'
    attributes = request.meshbluAuth.device
    meshbluConfig = request.meshbluAuth
    @shadowService.updateShadows {attributes, meshbluConfig}, (error) =>
      return @sendError {response, error} if error?
      response.sendStatus 204

  sendError: ({response,error}) =>
    response.status(error.code || 500).send error.message

module.exports = RealConfigController
