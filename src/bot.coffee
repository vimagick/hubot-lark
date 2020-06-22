try
  { Robot, Adapter, TextMessage, User } = require 'hubot'
catch
  prequire = require('parent-require')
  { Robot, Adapter, TextMessage, User } = prequire 'hubot'

WebhookService = require "./webhook_service"
LarkApiClient = require('./lark_api_client')

class LarkBot extends Adapter
  constructor: (@robot, @options) ->
    super
    @service = new WebhookService(@robot, @options.encrypt_key, @options.port)
    @service.run()
    @lark = new LarkApiClient(@options.api_id, @options.api_secret)
    @lark.auth() # get access token when lark bot init.

  send: (envelope, strings...) ->
    @robot.logger.info "Sending message to lark ====================="
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

module.exports = LarkBot
