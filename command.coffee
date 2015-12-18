### !pragma coverage-skip-block ###

MeshbluConfig = require 'meshblu-config'
Server        = require './src/server'

class Command
  constructor: ->
    meshbluConfig = new MeshbluConfig().toJSON()
    port = process.env.PORT || '80'

    @server = new Server {meshbluConfig,port}

  panic: (error) =>
    console.error error.message
    console.error error.stack
    process.exit 1

  run: =>
    @server.run (error) =>
      return @panic error if error?

      {address,port} = @server.address()
      console.log "Server running on #{address}:#{port}"

command = new Command
command.run()
