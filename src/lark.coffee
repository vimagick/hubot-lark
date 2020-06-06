try
  { Robot, Adapter, TextMessage, User } = require 'hubot'
catch
  prequire = require('parent-require')
  { Robot, Adapter, TextMessage, User } = prequire 'hubot'

WebhookService = require "./webhook_service"
LarkClient = require('./lark_client')

class Lark extends Adapter
  constructor: (@robot, @api_id, @api_key, @encrypt_key) ->
    super
    @service = new WebhookService(@robot, @encrypt_key)
    @service.run()
    @lark = new LarkClient(@api_id, @api_key)
    @lark.auth() # get access token when lark bot init.

  send: (envelope, strings...) ->
    @robot.logger.info "Sending message to lark ====================="
    @robot.logger.info strings
    @lark.message.directSend({
      chat_id: envelope.room,
      msg_type:"text",
      content: {
        text: strings.join("")
      }
    })

  reply: (envelope, strings...) ->
    @robot.logger.info "Reply message ========================="
    @lark.message.directSend({
      chat_id: envelope.room,
      msg_type:"text",
      content: {
        text: strings.join("")
      }
    })

  run: ->
    @robot.logger.info "Lark bot is running..."
    @emit "connected"

exports.use = (robot) ->
  # FIXME to pass secret from hubot
  API_ID = 'cli_9e418cfa73ead00d'
  API_SECRET = 'vTl6clSyfAVrZXaP3AlMfeJE1MILXkCu'
  ENCRYPT_KEY = 'NXSm0yFlQQoKH3OQ7JYzzf7KHxe5JQOl'

  new Lark robot, API_ID, API_SECRET, ENCRYPT_KEY
