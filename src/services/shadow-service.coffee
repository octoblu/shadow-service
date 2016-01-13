RealDevice = require '../models/real-device'
class ShadowService
  updateShadows: ({attributes, meshbluConfig}, callback) =>
    realDevice = new RealDevice {attributes, meshbluConfig}
    realDevice.updateShadows (error) =>
      return callback error if error?
      callback()

module.exports = ShadowService
