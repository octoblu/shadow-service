_           = require 'lodash'
async       = require 'async'
MeshbluHttp = require 'meshblu-http'

PROTECTED_FIELDS = [
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

  updateShadow: (realDeviceConfig, {uuid}, callback) =>
    @meshblu.device uuid, (error, virtualDevice) =>
      virtualDeviceConfig = _.omit virtualDevice, PROTECTED_FIELDS
      return callback() if _.isEqual realDeviceConfig, virtualDeviceConfig

      @meshblu.updateDangerously uuid, realDeviceConfig, callback

  updateShadows: (realDeviceUuid, callback) =>
    @meshblu.device realDeviceUuid, (error, realDevice) =>
      realDeviceConfig = _.omit realDevice, PROTECTED_FIELDS
      #it's fine, guys.
      updateShadow = _.partial(@updateShadow, realDeviceConfig)
      return callback error if error?
      async.each realDevice.shadows, updateShadow, callback

module.exports = RealDevice
