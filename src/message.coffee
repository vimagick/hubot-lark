try
  { User, Message, TextMessage } = require 'hubot'
catch
  prequire = require('parent-require')
  { User, Message, TextMessage } = prequire 'hubot'

_ = require "lodash"

class ReactionMessage extends Message
  constructor: (@type, @user, @reaction, @rawMessage) ->
    super @user
    @parent_id = @rawMessage.message_id

class LarkTextMessage extends TextMessage
  constructor: (@user, @text, @rawMessage) ->
    super @user, @text, @rawMessage.message_id
    @parent_id = @rawMessage.parent_id

class LarkMessage
  constructor: (@options) ->

  _getButtons: () ->
    {
      tag: "action",
      actions: @options.buttons.map (button) ->
        _.merge {
          tag: "button",
          text: {
            tag: "plain_text",
            content: "MISSING TEXT"
          },
          type: "default"
        }, button
    }

  _getConfig: () ->
    {
      card: {
        config: {
          wide_screen_mode: true
        }
      }
    }

  _getHeaders: () ->
    {
      card: {
        header: {
          title: {
            tag: "plain_text",
            content: @options.title || ""
          },
          template: @options.color || "red"
        }
      }
    }

  _getBody: () ->
    if @options.content?
      {
        tag: "div",
        text: {
          tag: "plain_text",
          content: @options.content
        }
      }

  _getExtraBody: () ->
    @options.extraBody

class LarkCardMessage extends LarkMessage
  _getCardContent: () ->
    {
      card: {
        elements: _.compact([
          @_getBody(),
          @_getExtraBody(),
          @_getButtons()
        ])
      }
    }

  toJson: () ->
    _.merge(@_getCardContent(), @_getHeaders(), @_getConfig())

  toString: () ->
    JSON.stringify _.merge(@_getCardContent(), @_getHeaders(), @_getConfig())

class LarkImageMessage extends LarkMessage
  _getCardContent: () ->
    {
      card: {
        elements: [
          @_getImage(),
        ]
      }
    }

  _getImage: () ->
    {
      tag: "img",
      img_key: @options.image_key,
      alt: {
        tag: "plain_text",
        content: @options.text
      }
    }

  toJson: () ->
    _.merge @_getConfig(), @_getCardContent()

  toString: () ->
    JSON.stringify _.merge @_getConfig(), @_getCardContent()

exports.ReactionMessage = ReactionMessage
exports.LarkTextMessage = LarkTextMessage
exports.LarkImageMessage = LarkImageMessage
exports.LarkCardMessage = LarkCardMessage
