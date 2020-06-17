try
  { TextMessage, User } = require 'hubot'
catch
  prequire = require('parent-require')
  { TextMessage, User } = prequire 'hubot'
express = require('express')
bodyParser = require('body-parser')
Cipher = require('./cipher')

class WebhookService
  constructor: (@robot, @encrypt_key) ->
    @app = express()
    @app.use bodyParser.json({ type: 'application/json' })
    @app.get '/', (req, res) =>
      res.send {ok: true}

    @app.post '/lark-integration', (req, res) =>
      cipher = new Cipher(@encrypt_key)
      msg = JSON.parse cipher.decrypt(req.body.encrypt)
      user = new User(msg.event.user, name: msg.event.user_open_id, room: msg.event.open_chat_id)
      textMsg = new TextMessage(user, msg.event.text_without_at_bot, msg.uuid)
      @robot.receive textMsg
      res.send { ok: true }

  run: ->
    server = @app.listen 9090, () =>
      host = server.address().address
      port = server.address().port
      @robot.logger.info("webhook service is running on http://#{host}:#{port}")

module.exports = WebhookService
