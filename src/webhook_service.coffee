express = require('express')
bodyParser = require('body-parser')
Cipher = require('./cipher')

try
  { TextMessage, User } = require 'hubot'
catch
  prequire = require('parent-require')
  { TextMessage, User } = prequire 'hubot'


ENCRYPT_KEY = 'NXSm0yFlQQoKH3OQ7JYzzf7KHxe5JQOl'

class WebhookService
  constructor: (@robot) ->
    @app = express()
    @app.use bodyParser.json({ type: 'application/json' })
    @app.get '/', (req, res) =>
      res.send {ok: true}

    @app.post '/lark-integration', (req, res) =>
      # user = new User 1001, name: 'Lark User'
      # message = new TextMessage user, 'run ls on localhost', 'MSG-001'
      # @robot.receive message

      cipher = new Cipher(ENCRYPT_KEY)
      message = cipher.decrypt req.body.encrypt
      result = JSON.parse(message)

      user = new User(result.event.user, name: result.event.user_open_id, room: result.event.open_chat_id)
      message = new TextMessage(user, result.event.text_without_at_bot, result.uuid)
      @robot.receive message

      console.log result

      res.send { ok: true }

  run: ->
    server = @app.listen 9090, () =>
      host = server.address().address
      port = server.address().port
      @robot.logger.info("webhook service is running on http://#{host}:#{port}")

module.exports = WebhookService
