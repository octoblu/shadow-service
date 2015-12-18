_ = require 'lodash'
MeshbluHttp = require 'meshblu-http'

OMITTED_FIELDS = [
  'uuid'
  'meshblu'
  'owner'
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
]

class ConfigController
  update: (request, response) =>
    return response.sendStatus 204 unless request.body.shadowing?.uuid?
    
    uuid   = request.body.shadowing.uuid
    config = _.omit request.body, OMITTED_FIELDS
    meshbluHttp = new MeshbluHttp request.meshbluAuth
    meshbluHttp.update uuid, config, (error) =>
      return @sendError {response, error} if error?
      response.status(204).end()

  sendError: ({response,error}) =>
    return response.status(500).send error.message unless error.code?
    return response.status(error.code).send error.message


module.exports = ConfigController
