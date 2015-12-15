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
]

class ConfigController
  update: (request, result) =>
    config = _.omit request.body, OMITTED_FIELDS
    {uuid} = request.meshbluAuth
    meshbluHttp = new MeshbluHttp request.meshbluAuth
    meshbluHttp.update uuid, config, (error) =>
      result.status(422).send(error.message) if error?
      result.status(204).end()

module.exports = ConfigController
