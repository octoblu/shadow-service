morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
errorHandler       = require 'errorhandler'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
meshbluAuth        = require 'express-meshblu-auth'
debug              = require('debug')('team-device-service:server')
Router             = require './router'

class Server
  constructor: ({@port,@meshbluConfig, @disableLogging})->

  address: =>
    @server.address()

  run: (callback) =>
    app = express()
    app.use morgan 'dev', immediate: false unless @disableLogging
    app.use errorHandler()
    app.use meshbluHealthcheck()
    app.use meshbluAuth @meshbluConfig
    app.use bodyParser.urlencoded limit: '50mb', extended : true
    app.use bodyParser.json limit : '50mb'

    router = new Router meshbluConfig: @meshbluConfig
    router.route app

    @server = app.listen @port, callback

  stop: (callback) =>
    @server.close callback

module.exports = Server
