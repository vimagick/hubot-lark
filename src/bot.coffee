try
  { Robot, Adapter, TextMessage, User } = require 'hubot'
catch
  prequire = require('parent-require')
  { Robot, Adapter, TextMessage, User } = prequire 'hubot'

_ = require "lodash"
LarkApiClient = require './lark_api_client'
{ LarkCardMessage, LarkImageMessage } = require './message'

class LarkBot extends Adapter
  constructor: (@robot, @options) ->
    super
    @lark = new LarkApiClient(@options.api_id, @options.api_secret)

  send: (envelope, strings...) ->
    @robot.logger.debug "Lark bot sent message to Lark ..."
    @_sendMessage(envelope, strings, false)

  reply: (envelope, strings...) ->
    @robot.logger.debug "Lark bot replied message ..."
    @_sendMessage(envelope, strings, true)

  _sendMessage: (envelope, strings, reply) ->
    _.each strings, (item) =>
      msg = null
      if item instanceof LarkCardMessage
        msg = _.merge(item.toJson(), {
          chat_id: envelope.room,
          msg_type: "interactive",
          update_multi: true
        })
      else if item instanceof LarkImageMessage
        msg = _.merge(item.toJson(), {
          chat_id: envelope.room,
          msg_type: "interactive",
          update_multi: true
        })
      else
        msg = {
          chat_id: envelope.room,
          msg_type: "text",
          content: {
            text: (if reply then "<at user_id="#{envelope.user.id}">#{envelope.user.name}</at>: #{item}" else item)
          }
        }
      @lark.messageDirectSend msg

  run: ->
    @robot.logger.info "Lark bot is connected ..."
    @emit "connected"

module.exports = LarkBot
