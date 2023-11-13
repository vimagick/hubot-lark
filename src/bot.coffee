
try
  { Robot, Adapter, TextMessage, User } = require 'hubot'
catch
  prequire = require('parent-require')
  { Robot, Adapter, TextMessage, User } = prequire 'hubot'

_ = require "lodash"
LarkApiClient = require './lark_api_client'
WebhookService = require './webhook_service'
{ LarkCardMessage, LarkImageMessage } = require './message'

class LarkBot extends Adapter
  constructor: (@robot, @options) ->
    super()
    @lark = new LarkApiClient(@options.api_id, @options.api_secret)

  send: (envelope, strings...) ->
    @robot.logger.info "Lark bot sent message to Lark ..."
    @_sendMessage(envelope, strings)

  reply: (envelope, strings...) ->
    @robot.logger.info "Lark bot replied message ..."
    @_sendMessage(envelope, strings)

  _sendMessage: (envelope, strings) ->
    _.each strings, (item) =>
      if item instanceof LarkCardMessage
        msg = _.merge(item.toJson(), {
          chat_id: envelope.room,
          msg_type: "interactive",
          update_multi: true
        })
        @lark.messageDirectSend msg
      else if item instanceof LarkImageMessage
        msg = _.merge(item.toJson(), {
          chat_id: envelope.room,
          msg_type: "interactive",
          update_multi: true
        })
        @lark.messageDirectSend msg
      else
        @lark.messageDirectSend {
          chat_id: envelope.room,
          msg_type: "text",
          content: {
            text: item
          }
        }

  run: ->
    @robot.logger.info "Lark bot is connected ..."
    new WebhookService(@robot, @options)
    @emit "connected"

module.exports = LarkBot
