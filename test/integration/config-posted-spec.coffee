http = require 'http'
request = require 'request'
shmock = require 'shmock'
Server = require '../../src/server'

describe 'POST /config', ->
  beforeEach ->
    @meshblu = shmock 0xb33f

  afterEach (done) ->
    @meshblu.close => done()

  beforeEach (done) ->
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
    @server.stop => done()

  beforeEach (done) ->
    auth =
      username: 'the-real-uuid'
      password: 'the-real-token'

    device =
      uuid: 'the-real-uuid'
      foo: 'bar'
      meshblu: 'pwned!'
      owner: 'someone-else'
      token: 'steal-me'
      sendWhitelist: []
      receiveWhitelist: []
      configureWhitelist: []
      discoverWhitelist: []
      sendBlacklist: []
      recieveBlacklist: []
      configureBlacklist: []
      discoverBlacklist: []
      sendAsWhitelist: []
      receiveAsWhitelist: []
      configureAsWhitelist: []
      discoverAsWhitelist: []

    options =
      auth: auth
      json: device

    @whoamiHandler = @meshblu.get('/v2/whoami')
      .reply(200, '{"uuid": "the-real-uuid"}')

    basicAuth = new Buffer('the-real-uuid:the-real-token').toString('base64')

    @patchHandler = @meshblu.patch('/v2/devices/the-real-uuid')
      .set 'Authorization', "Basic #{basicAuth}"
      .send foo: 'bar'
      .reply 204, http.STATUS_CODES[204]

    request.post "http://localhost:#{@serverPort}/config", options, (@error, @response, @body) =>
      done @error

  it 'should update the real device in meshblu', ->
    expect(@response.statusCode).to.equal 204

  it 'should call the patch handler', ->
    expect(@patchHandler.isDone).to.be.true

  it 'should call the whoami handler', ->
    expect(@whoamiHandler.isDone).to.be.true
