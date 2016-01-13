http = require 'http'
request = require 'request'
shmock = require '@octoblu/shmock'
Server = require '../../src/server'

describe 'POST /virtual/config', ->
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

  describe 'when a valid shadow request is made', ->
    beforeEach (done) ->
      teamAuth = new Buffer('team-uuid:team-token').toString('base64')

      @whoamiHandler = @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{teamAuth}"
        .reply 200, uuid: 'team-uuid'

      @meshblu
        .get '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{teamAuth}"
        .reply 200,
          uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/virtual-device-uuid'
        .set 'Authorization', "Basic #{teamAuth}"
        .reply 200, uuid: 'virtual-device-uuid', foo: 'bar', shadowing: {uuid: 'real-device-uuid'}

      @updateRealMeshbluDevice = @meshblu
        .patch '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{teamAuth}"
        .send foo: 'bar'
        .reply 204

      options =
        baseUrl: "http://localhost:#{@serverPort}"
        uri: '/virtual/config'
        auth:
          username: 'team-uuid'
          password: 'team-token'
        json:
          uuid: 'virtual-device-uuid'
          foo: 'bar'
          shadowing: {uuid: 'real-device-uuid'}

      request.post options, (error, @response, @body) => done error

    it 'should return a 204', ->
      expect(@response.statusCode).to.equal 204, @body

    it 'should update the real meshblu device', ->
      @updateRealMeshbluDevice.done()

  describe 'when a valid shadow request is made, but the config hasn\'t changed', ->
    beforeEach (done) ->
      teamAuth = new Buffer('team-uuid:team-token').toString('base64')

      @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{teamAuth}"
        .reply 200,
          uuid: 'team-uuid'

      @meshblu
        .get '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{teamAuth}"
        .reply 200,
          uuid: 'real-device-uuid'
          fresh: 'soup'

      @meshblu
        .get '/v2/devices/virtual-device-uuid'
        .set 'Authorization', "Basic #{teamAuth}"
        .reply 200, uuid: 'virtual-device-uuid', fresh: 'soup', shadowing: {uuid: 'real-device-uuid'}

      options =
        baseUrl: "http://localhost:#{@serverPort}"
        uri: '/virtual/config'
        auth:
          username: 'team-uuid'
          password: 'team-token'
        json:
          uuid: 'virtual-device-uuid'
          fresh: 'soup'
          shadowing: {uuid: 'real-device-uuid'}

      request.post options, (error, @response, @body) => done error

    it 'shouldn\'t update the real device', ->
      expect(@response.statusCode).to.equal 204, @body

  describe 'when the device is not shadowing', ->
    beforeEach (done) ->
      teamAuth = new Buffer('team-uuid:team-token').toString('base64')

      @whoamiHandler = @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{teamAuth}"
        .reply 200, uuid: 'team-uuid'

      @meshblu
        .get '/v2/devices/virtual-uuid'
        .set 'Authorization', "Basic #{teamAuth}"
        .reply 200, uuid: 'virtual-uuid'

      options =
        baseUrl: "http://localhost:#{@serverPort}"
        uri: '/virtual/config'
        auth:
          username: 'team-uuid'
          password: 'team-token'
        json:
          uuid: 'virtual-uuid'
          foo: 'bar'

      request.post options, (error, @response, @body) => done error

    it 'should return a 204', ->
      expect(@response.statusCode).to.equal 204, @body

  describe 'when the auth is insufficient to update the real device', ->
    beforeEach (done) ->
      teamAuth = new Buffer('team-uuid:team-token').toString('base64')

      @whoamiHandler = @meshblu
        .get '/v2/whoami'
        .set 'Authorization', "Basic #{teamAuth}"
        .reply 200, uuid: 'team-uuid'

      @meshblu
        .get '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{teamAuth}"
        .reply 200,
          uuid: 'real-device-uuid'

      @meshblu
        .get '/v2/devices/virtual-device-uuid'
        .set 'Authorization', "Basic #{teamAuth}"
        .reply 200, uuid: 'virtual-device-uuid', foo: 'bar', shadowing: {uuid: 'real-device-uuid'}

      @updateRealMeshbluDevice = @meshblu
        .patch '/v2/devices/real-device-uuid'
        .set 'Authorization', "Basic #{teamAuth}"
        .send foo: 'bar'
        .reply 403

      options =
        baseUrl: "http://localhost:#{@serverPort}"
        uri: '/virtual/config'
        auth:
          username: 'team-uuid'
          password: 'team-token'
        json:
          uuid: 'virtual-device-uuid'
          foo: 'bar'
          shadowing: {uuid: 'real-device-uuid'}

      request.post options, (error, @response, @body) => done error

    it 'should update the real meshblu device', ->
      @updateRealMeshbluDevice.done()

    it 'should return a 403', ->
      expect(@response.statusCode).to.equal 403, @body
