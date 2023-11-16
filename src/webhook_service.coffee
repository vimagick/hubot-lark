try
  { TextMessage, User } = require 'hubot'
catch
  prequire = require('parent-require')
  { TextMessage, User } = prequire 'hubot'

express = require('express')
bodyParser = require('body-parser')
Cipher = require('./cipher')
{ ReactionMessage, LarkTextMessage } = require('./message')

class WebhookService
  constructor: (@robot, @config) ->
    if !@config.port?
      console.warn "missing port in config so the Lark webhook service won't start, please pass env HUBOT_LARK_PORT=8080 to start the Lark webhook service"
      return

    if !@config.encrypt_key?
      throw "missing encrypt key in config, please pass env LARK_ENCRYPT_KEY=xxxxxxxxx"
      return

    @app = express()
    @app.use bodyParser.json { type: 'application/json' }

    # Used for site health check.
    @app.get '/', (req, res) =>
      res.send { ok: true }

    @app.post '/lark-integration', (req, res) =>
      if req.body.encrypt?
        cipher = new Cipher @config.encrypt_key
        body = cipher.decrypt req.body.encrypt
        data = JSON.parse body
      else
        data = req.body

      @robot.logger.debug JSON.stringify(data, null, 2)

      if data.challenge?
        res.send { challenge: data.challenge }
        return

      if data.header?.event_type == 'im.message.receive_v1'
        user = new User(
          data.event.sender.sender_id.open_id,
          name: data.event.sender.sender_id.open_id,
          room: data.event.message.chat_id
        )
        content = JSON.parse data.event.message.content
        if content.text?
          text = content.text
          for m in (data.event.message.mentions or [])
            text = text.replace(m.key, "@#{m.name}")
          message = new LarkTextMessage(
            user,
            text,
            data.event.message
          )
          @robot.receive message

      if data.header?.event_type in ['im.message.reaction.created_v1', 'im.message.reaction.deleted_v1']
        user = null
        if data.event.operator_type == 'user'
          user = new User(
            data.event.user_id.open_id,
            name: data.event.user_id.open_id,
            room: null
          )
        else
          user = new User(
            '',
            name: '',
            room: null
          )
        if data.event.reaction_type.emoji_type?
          type = if data.header.event_type == 'im.message.reaction.created_v1' then 'added' else 'removed'
          reaction = data.event.reaction_type.emoji_type
          message = new ReactionMessage(
            type,
            user,
            reaction,
            data.event
          )
          @robot.receive message

      res.send { ok: true }

    @app.post '/lark-card-integration', (req, res) =>
      data = req.body

      @robot.logger.debug JSON.stringify(data, null, 2)

      if data.challenge?
        res.send { challenge: data.challenge }
        return

      res.send { ok: true }

    # start service after init.
    @run()

  run: ->
    server = @app.listen @config.port, '0.0.0.0', () =>
      host = server.address().address
      port = server.address().port
      @robot.logger.info "Webhook service is running on http://#{host}:#{port} ......"

module.exports = WebhookService
