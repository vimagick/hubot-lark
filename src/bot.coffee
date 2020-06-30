try
  { Robot, Adapter, TextMessage, User } = require 'hubot'
  { LarkCardMessage, LarkImageMessage } = require './message'
catch
  prequire = require('parent-require')
  { Robot, Adapter, TextMessage, User } = prequire 'hubot'
  { LarkCardMessage, LarkImageMessage } = prequire './message'

_ = require "lodash"

LarkApiClient = require('./lark_api_client')

class LarkBot extends Adapter
  constructor: (@robot, @options) ->
    super
    @lark = new LarkApiClient(@options.api_id, @options.api_secret)
    @lark.auth() # get access token when lark bot init.

  send: (envelope, strings...) ->
    @robot.logger.info "Sending message to lark ====================="

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

  reply: (envelope, strings...) ->
    @robot.logger.info "Reply message ========================="
    @lark.messageDirectSend({
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
