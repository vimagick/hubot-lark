try
  { Robot, Adapter, TextMessage, User } = require 'hubot'
catch
  prequire = require('parent-require')
  { Robot, Adapter, TextMessage, User } = prequire 'hubot'

WebhookService = require "./webhook_service"
LarkClient = require('./lark_client')

class Lark extends Adapter
  constructor: (@robot) ->
    super
    @service = new WebhookService(@robot)
    @service.run()
    @lark = new LarkClient('cli_9e418cfa73ead00d', 'vTl6clSyfAVrZXaP3AlMfeJE1MILXkCu')
    @lark.auth()

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
    @robot.logger.info "Reply message ====================="
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
  new Lark robot
