_           = require 'lodash'
async       = require 'async'
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
  'geo'
  'hash'
  'ip'
]
class VirtualDevice
  constructor: ({meshbluConfig}) ->
    @meshblu = new MeshbluHttp meshbluConfig

  updateRealDevice: (virtualDeviceUuid, callback) =>
    @meshblu.device virtualDeviceUuid, (error, virtualDevice) =>
      return callback error if error?

      realDeviceUuid = virtualDevice.shadowing?.uuid
      return callback() unless realDeviceUuid?

      virtualDeviceConfig = _.omit virtualDevice, OMITTED_FIELDS
      @meshblu.device realDeviceUuid, (error, realDevice) =>
        return callback error if error?

        realDeviceConfig = _.omit realDevice, OMITTED_FIELDS
        return callback() if _.isEqual virtualDeviceConfig, realDeviceConfig

        @meshblu.update realDeviceUuid, virtualDeviceConfig, (error) =>
          return callback error if error?
          callback()

module.exports = VirtualDevice
