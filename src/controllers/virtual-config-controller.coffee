_           = require 'lodash'
debug       = require('debug')('shadow-service:virtual-config-controller')
MeshbluHttp = require 'meshblu-http'

OMITTED_FIELDS = [
  'uuid'
  'meshblu'
  'owner'
  'type'
  'name'
  'token'
  'sendWhitelist'
  'receiveWhitelist'
  'configureWhitelist'
  'discoverWhitelist'
  'sendBlacklist'
  'recieveBlacklist'
  'configureBlacklist'
  'discoverBlacklist'
  'sendAsWhitelist'
  'receiveAsWhitelist'
  'configureAsWhitelist'
  'discoverAsWhitelist'
  'shadowing'
  'shadows'
]

class VirtualConfigController
  update: (request, response) =>
    return response.sendStatus 204 unless request.body.shadowing?.uuid?

    realDeviceUuid   = request.body.shadowing.uuid
    config = _.omit request.body, OMITTED_FIELDS
    debug 'virtualDevice: updateReal'

    meshbluHttp = new MeshbluHttp request.meshbluAuth
    meshbluHttp.device realDeviceUuid, (error, realDevice) =>
      return @sendError {response, error} if error?

      return response.sendStatus(204) if _.isEqual config, _.omit(realDevice, OMITTED_FIELDS)
      meshbluHttp.update realDeviceUuid, config, (error) =>
        return @sendError {response, error} if error?
        debug "204: update success"
        response.sendStatus(204)

  sendError: ({response,error}) =>
    debug "500: #{error.message}" unless error.code?
    return response.status(500).send error.message unless error.code?
    debug "#{error.code}: #{error.message}"
    return response.status(error.code).send error.message

module.exports = VirtualConfigController
