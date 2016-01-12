_           = require 'lodash'
async       = require 'async'
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
  'shadows'
  'geo'
  'hash'
  'ip'
]

class RealDevice
  constructor: ({@attributes,meshbluConfig}) ->
    @meshblu = new MeshbluHttp meshbluConfig

  messageShadows: ({message}, callback) =>
    async.each @attributes.shadows, (shadow, callback) =>
      @meshblu.message message, as: shadow.uuid, callback
    , callback

  updateShadow: ({uuid}, callback) =>
    newAttributes = _.omit @attributes, OMITTED_FIELDS
    @meshblu.device uuid, (error, device) =>
      existingAttributes = _.omit device, OMITTED_FIELDS
      return callback() if _.isEqual newAttributes, existingAttributes

      @meshblu.update uuid, newAttributes, callback

  updateShadows: (callback) =>
    async.each @attributes.shadows, @updateShadow, callback

module.exports = RealDevice
