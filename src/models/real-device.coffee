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
  constructor: ({@attributes, meshbluConfig}) ->
    @meshblu = new MeshbluHttp meshbluConfig

  messageShadows: ({realDeviceUuid, message}, callback) =>
    async.each @attributes.shadows, (shadow, callback) =>
      @meshblu.message message, as: shadow.uuid, callback
    , callback

  updateShadow: (device, {uuid}, callback) =>
    newAttributes = _.omit device, OMITTED_FIELDS
    @meshblu.device uuid, (error, device) =>
      existingAttributes = _.omit device, OMITTED_FIELDS
      return callback() if _.isEqual newAttributes, existingAttributes

      @meshblu.update uuid, newAttributes, callback

  updateShadows: (realDeviceUuid, callback) =>
    @meshblu.device realDeviceUuid, (error, device) =>
      #it's fine, guys.
      updateShadow = _.partial(@updateShadow, device)
      return callback error if error?
      async.each device.shadows, updateShadow, callback

module.exports = RealDevice
