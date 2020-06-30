try
  { User } = require 'hubot'
catch
  prequire = require('parent-require')
  { User } = prequire 'hubot'

_ = require "lodash"

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
    {
      tag: "div",
      text: {
        tag: "plain_text",
        content: @options.content
      }
    }

class LarkCardMessage extends LarkMessage
  _getCardContent: () ->
    {
      card: {
        elements: [
          @_getBody(),
          @_getButtons()
        ]
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

exports.LarkImageMessage = LarkImageMessage
exports.LarkCardMessage = LarkCardMessage
