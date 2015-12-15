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
  constructor: ({meshbluConfig}) ->
    @meshbluHttp = new MeshbluHttp meshbluConfig

  update: (req, res) =>
    {id} = req.params
    config = _.omit req.body, OMITTED_FIELDS
    @meshbluHttp.update id, config, (error) =>
      res.status(422).send(error.message) if error?
      res.status(204).end()

module.exports = ConfigController
