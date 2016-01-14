RealDevice = require '../models/real-device'
VirtualDevice = require '../models/virtual-device'
class ShadowService
  syncShadowDevices: ({realDeviceUuid, meshbluConfig}, callback) =>
    realDevice = new RealDevice {meshbluConfig}
    realDevice.updateShadows realDeviceUuid, (error) =>
      return callback error if error?
      callback()

  syncRealDevice: ({virtualDeviceUuid, meshbluConfig}, callback) =>
    virtualDevice     = new VirtualDevice {meshbluConfig}
    virtualDevice.updateRealDevice virtualDeviceUuid, callback

module.exports = ShadowService
