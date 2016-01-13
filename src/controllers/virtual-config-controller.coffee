_           = require 'lodash'
debug       = require('debug')('shadow-service:virtual-config-controller')
MeshbluHttp = require 'meshblu-http'
VirtualDevice = require '../models/virtual-device'

class VirtualConfigController
  update: (request, response) =>
    meshbluConfig     = request.meshbluAuth
    realDeviceUuid    = request.body.shadowing?.uuid
    virtualDeviceUuid = request.body.uuid
    virtualDevice     = new VirtualDevice {meshbluConfig}

    virtualDevice.updateRealDevice {virtualDeviceUuid, realDeviceUuid}, (error) =>
      return @sendError {response, error} if error?
      response.sendStatus 204

  sendError: ({response,error}) =>
    return response.status(error.code || 500).send error.message

module.exports = VirtualConfigController
