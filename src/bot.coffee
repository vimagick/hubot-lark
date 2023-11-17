try
  { Robot, Adapter, TextMessage, User } = require 'hubot'
catch
  prequire = require('parent-require')
  { Robot, Adapter, TextMessage, User } = prequire 'hubot'

_ = require "lodash"
LarkApiClient = require './lark_api_client'
{ LarkCardMessage, LarkImageMessage } = require './message'

class LarkBot extends Adapter
  constructor: (robot, options) ->
    super arguments...
    this.robot = robot
    this.options = options
    this.lark = new LarkApiClient(this.options.api_id, this.options.api_secret)
    
  send: (envelope, messages...) ->
    callback = ->
    if typeof(messages[messages.length - 1]) == "function"
      callback = messages.pop()
    messagePromises = messages.map (message) =>
      return Promise.resolve() if typeof(message) is "function"
      @_sendMessage(envelope, message, false) unless message is ""
    Promise.all(messagePromises).then(callback.bind(null, null), callback)

  reply: (envelope, messages...) ->
    callback = ->
    if typeof(messages[messages.length - 1]) == "function"
      callback = messages.pop()
    messagePromises = messages.map (message) =>
      return Promise.resolve() if typeof(message) is "function"
      @_sendMessage(envelope, message, true) unless message is ""
    Promise.all(messagePromises).then(callback.bind(null, null), callback)

  _sendMessage: (envelope, item, reply) ->
    msg =
      receive_id: envelope.room
      msg_type: null
      content: null
    switch item.constructor
      when Object
        msg.msg_type = "interactive"
        msg.content = JSON.stringify item
      else
        msg.msg_type = "text"
        msg.content = JSON.stringify text: (if reply then "<at user_id=\"#{envelope.user.id}\">#{envelope.user.name}</at>: #{item}" else item)
    @lark.messageSend msg

  run: ->
    @robot.logger.info "Lark bot is connected ..."
    @emit "connected"

module.exports = LarkBot
