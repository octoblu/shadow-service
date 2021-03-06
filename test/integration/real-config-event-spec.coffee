http = require 'http'
request = require 'request'
shmock = require '@octoblu/shmock'
Server = require '../../src/server'

describe 'POST /real/config', ->
  beforeEach (done) ->
    @meshblu = shmock 0xb33f

    meshbluConfig =
      server: 'localhost'
      port: 0xb33f

    @server = new Server
      port: undefined
      meshbluConfig: meshbluConfig
      disableLogging: true

    @server.run =>
      @serverPort = @server.address().port
      done()

  afterEach (done) ->
    @meshblu.close done

  afterEach (done) ->
    @server.stop done

  describe 'when a real device has 1 shadow', ->
    beforeEach (done) ->
      deviceAuth = new Buffer('real-device-uuid:real-device-token').toString('base64')

      @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200,
          uuid: 'real-device-uuid',
          foo: 'bar',
          shadows: [{uuid: 'virtual-device-uuid'}],
          shadowing: 'blah'
          discoverWhitelist: ['*']

      @meshblu
        .get '/v2/devices/virtual-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'virtual-device-uuid', shadowing: {uuid: 'real-device-uuid'}

      @updateVirtualMeshbluDevice = @meshblu
        .put '/v2/devices/virtual-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .send
          uuid: 'virtual-device-uuid'
          foo: 'bar'
          shadowing: {uuid: 'real-device-uuid'}
        .reply 204

      options =
        baseUrl: "http://localhost:#{@serverPort}"
        uri: '/real/config'
        auth:
          username: 'real-device-uuid'
          password: 'real-device-token'
        json:
          uuid: 'real-device-uuid'
          foo: 'bar'
          shadows: [{uuid: 'virtual-device-uuid'}]

      request.post options, (error, @response, @body) => done error

    it 'should return a 204', ->
      expect(@response.statusCode).to.equal 204, @body

    it 'should update the virtual meshblu device', ->
      @updateVirtualMeshbluDevice.done()

  describe 'when a real device does not have permission to update the shadow', ->
    beforeEach (done) ->
      deviceAuth = new Buffer('real-device-uuid:real-device-token').toString('base64')

      @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200,
          uuid: 'real-device-uuid',
          egon: 'is the worst',
          peter: 'is so funny'
          shadows: [{uuid: 'virtual-device-uuid'}]

      @meshblu
        .get '/v2/devices/virtual-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200,
          uuid: 'virtual-device-uuid',
          egon: 'is the worst',
          slimer: 'is the best',
          shadowing: uuid: 'real-device-uuid'

      @meshblu
        .put '/v2/devices/virtual-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .send
          uuid: 'virtual-device-uuid'
          egon: 'is the worst'
          peter: 'is so funny'
          shadowing: uuid: 'real-device-uuid'
        .reply 403

      options =
        baseUrl: "http://localhost:#{@serverPort}"
        uri: '/real/config'
        auth:
          username: 'real-device-uuid'
          password: 'real-device-token'
        json:
          uuid: 'real-device-uuid'
          foo: 'bar'
          shadows: [{uuid: 'virtual-device-uuid'}]

      request.post options, (error, @response, @body) => done error

    it 'should return a 403', ->
      expect(@response.statusCode).to.equal 403, @body

  describe 'when a real device has no shadow', ->
    beforeEach (done) ->
      deviceAuth = new Buffer('real-device-uuid:real-device-token').toString('base64')

      @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      options =
        baseUrl: "http://localhost:#{@serverPort}"
        uri: '/real/config'
        auth:
          username: 'real-device-uuid'
          password: 'real-device-token'
        json:
          uuid: 'real-device-uuid'
          foo: 'bar'

      request.post options, (error, @response, @body) => done error

    it 'should return a 204', ->
      expect(@response.statusCode).to.equal 204, @body

  describe 'when a real device has 1 shadow that is already up-to-date', ->
    beforeEach (done) ->
      deviceAuth = new Buffer('real-device-uuid:real-device-token').toString('base64')

      @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/virtual-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'virtual-device-uuid', foo: 'bar'

      options =
        baseUrl: "http://localhost:#{@serverPort}"
        uri: '/real/config'
        auth:
          username: 'real-device-uuid'
          password: 'real-device-token'
        json:
          uuid: 'real-device-uuid'
          foo: 'bar'
          shadows: [{uuid: 'virtual-device-uuid'}]

      request.post options, (error, @response, @body) => done error

    it 'should return a 204 without trying to update the virtual device', ->
      expect(@response.statusCode).to.equal 204, @body

  describe 'when a real device has 1 shadow and it\'s geo information is updated', ->
    beforeEach (done) ->
      deviceAuth = new Buffer('real-device-uuid:real-device-token').toString('base64')

      @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/virtual-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200,
          uuid: 'virtual-device-uuid'
          foo: 'bar'
          geo: 'mordavia'

      options =
        baseUrl: "http://localhost:#{@serverPort}"
        uri: '/real/config'
        auth:
          username: 'real-device-uuid'
          password: 'real-device-token'
        json:
          uuid: 'real-device-uuid'
          foo: 'bar'
          geo: 'valhalla'
          shadows: [{uuid: 'virtual-device-uuid'}]

      request.post options, (error, @response, @body) => done error

    it 'should return a 204 without trying to update the virtual device', ->
      expect(@response.statusCode).to.equal 204, @body


  describe 'when a real device has 1 shadow and it\'s hash information is updated', ->
    beforeEach (done) ->
      deviceAuth = new Buffer('real-device-uuid:real-device-token').toString('base64')

      @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/virtual-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200,
          uuid: 'virtual-device-uuid'
          foo: 'bar'
          hash: 'mordavia'

      options =
        baseUrl: "http://localhost:#{@serverPort}"
        uri: '/real/config'
        auth:
          username: 'real-device-uuid'
          password: 'real-device-token'
        json:
          uuid: 'real-device-uuid'
          foo: 'bar'
          hash: 'valhalla'
          shadows: [{uuid: 'virtual-device-uuid'}]

      request.post options, (error, @response, @body) => done error

    it 'should return a 204 without trying to update the virtual device', ->
      expect(@response.statusCode).to.equal 204, @body

  describe 'when a real device has 1 shadow and it\'s ip information is updated', ->
    beforeEach (done) ->
      deviceAuth = new Buffer('real-device-uuid:real-device-token').toString('base64')

      @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200, uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/virtual-device-uuid'
        .set 'Authorization', "Basic #{deviceAuth}"
        .reply 200,
          uuid: 'virtual-device-uuid'
          foo: 'bar'
          ip: 'mordavia'

      options =
        baseUrl: "http://localhost:#{@serverPort}"
        uri: '/real/config'
        auth:
          username: 'real-device-uuid'
          password: 'real-device-token'
        json:
          uuid: 'real-device-uuid'
          foo: 'bar'
          ip: 'valhalla'
          shadows: [{uuid: 'virtual-device-uuid'}]

      request.post options, (error, @response, @body) => done error

    it 'should return a 204 without trying to update the virtual device', ->
      expect(@response.statusCode).to.equal 204, @body
