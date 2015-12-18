_           = require 'lodash'
async       = require 'async'
MeshbluHttp = require 'meshblu-http'

OMITTED_FIELDS = ['uuid', 'shadows']

class RealDevice
  constructor: ({@attributes,meshbluConfig}) ->
    @meshblu = new MeshbluHttp meshbluConfig

  updateShadow: ({uuid}, callback) =>
    attributes = _.omit @attributes, OMITTED_FIELDS
    @meshblu.update uuid, attributes, callback

  updateShadows: (callback) =>
    async.each @attributes.shadows, @updateShadow, callback

module.exports = RealDevice
