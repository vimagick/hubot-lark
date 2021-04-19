try
  { TextMessage, User } = require 'hubot'
catch
  prequire = require('parent-require')
  { TextMessage, User } = prequire 'hubot'

express = require('express')
bodyParser = require('body-parser')
Cipher = require('./cipher')

class WebhookService
  constructor: (@robot, @config) ->
    if !@config.port?
      console.warn "missing port in config so the Lark webhook service won't start, please pass env HUBOT_LARK_PORT=8080 to start the Lark webhook service"
      return

    if !@config.encrypt_key?
      throw "missing encrypt key in config, please pass env LARK_ENCRYPT_KEY=xxxxxxxxx"
      return

    @app = express()
    @app.use bodyParser.json { type: 'application/json' }

    # Used for site health check.
    @app.get '/', (req, res) =>
      res.send { ok: true }

    @app.post '/lark-integration', (req, res) =>
      cipher = new Cipher @config.encrypt_key
      body = cipher.decrypt req.body.encrypt
      data = JSON.parse body

      if data.challenge?
        res.send { challenge: data.challenge }
        return

      user = new User(
        data.event.sender.sender_id.open_id,
        name: data.event.sender.sender_id.open_id,
        room: data.event.message.chat_id
      )
      message = new TextMessage(
        user,
        data.event.message.content,
        data.event.message.message_id
      )
      @robot.receive message
      res.send { ok: true }

    @app.post '/lark-card-integration', (req, res) ->
      msg = req.body

      if msg.challenge
        res.send { challenge: msg.challenge }
        return

      # TODO
      # if you want to handle card callbacks, you will implement a lot business logic, which is suppose not appear here.
      # that's why I suggest you'd better to implement this port into your app by using:
      # robot.router.post '/lark-card-integration', (req, res)
      res.send { ok: true }

    # start service after init.
    @run()

  run: ->
    server = @app.listen @config.port, '0.0.0.0', () =>
      host = server.address().address
      port = server.address().port
      @robot.logger.info "Webhook service is running on http://#{host}:#{port} ......"

module.exports = WebhookService
