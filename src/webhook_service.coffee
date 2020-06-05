express = require('express')
bodyParser = require('body-parser')
Cipher = require('./cipher')
LarkClient = require('./lark_client')

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
      # user = new User 1001, name: 'Lark User'
      # message = new TextMessage user, 'Some Lark Message', 'MSG-001'
      # @robot.receive message

      res.send {ok: true}

    @app.post '/lark-integration', (req, res) =>
      # user = new User 1001, name: 'Lark User'
      # message = new TextMessage user, 'run ls on localhost', 'MSG-001'
      # @robot.receive message

      cipher = new Cipher(ENCRYPT_KEY)
      message = cipher.decrypt req.body.encrypt
      result = JSON.parse(message)
      console.log result

      user = new User 1001, name: 'Lark User'
      message = new TextMessage user, result.event.text_without_at_bot, 'MSG-001'
      @robot.receive message

      lark = new LarkClient 'cli_9e418cfa73ead00d', 'vTl6clSyfAVrZXaP3AlMfeJE1MILXkCu'
      lark.auth()
        .then ->
          lark.message.directSend({
            chat_id: result.event.open_chat_id,
            msg_type:"text",
            content: {
              text: "text content"
            }
          })

      res.send {}

  run: ->
    server = @app.listen 9090, () =>
      host = server.address().address
      port = server.address().port
      @robot.logger.info("webhook service is running on http://#{host}:#{port}")

module.exports = WebhookService
