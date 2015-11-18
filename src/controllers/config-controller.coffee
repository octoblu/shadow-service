_ = require 'lodash'
MeshbluHttp = require 'meshblu-http'

OMITTED_FIELDS = [
  'uuid'
  'meshblu'
  'owner'
  'token'
  'sendWhitelist'
  'recieveWhitelist'
  'configWhitelist'
  'discoverWhitelist'
  'sendBlacklist'
  'recieveBlacklist'
  'configBlacklist'
  'discoverBlacklist'
  'sendAsWhitelist'
  'recieveAsWhitelist'
  'configAsWhitelist'
  'discoverAsWhitelist'
]

class ConfigController
  constructor: ({meshbluConfig}) ->
    @meshbluHttp = new MeshbluHttp meshbluConfig

  update: (req, res) =>
    {id} = req.params
    config = _.omit req.body, OMITTED_FIELDS
    @meshbluHttp.update id, config, (error) =>
      res.send(204).end()

module.exports = ConfigController
