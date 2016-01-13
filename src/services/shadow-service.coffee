RealDevice = require '../models/real-device'
VirtualDevice = require '../models/virtual-device'
class ShadowService
  updateShadows: ({attributes, meshbluConfig}, callback) =>
    realDevice = new RealDevice {attributes, meshbluConfig}
    realDevice.updateShadows (error) =>
      return callback error if error?
      callback()

  updateRealDevice: ({virtualDeviceUuid, meshbluConfig}, callback) =>
    virtualDevice     = new VirtualDevice {meshbluConfig}
    virtualDevice.updateRealDevice virtualDeviceUuid, callback

module.exports = ShadowService
