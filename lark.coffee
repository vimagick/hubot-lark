LarkBot = require './src/bot'

exports.ReactionMessage = require('./src/message').ReactionMessage
exports.LarkTextMessage = require('./src/message').LarkTextMessage
exports.LarkImageMessage = require('./src/message').LarkImageMessage
exports.LarkCardMessage = require('./src/message').LarkCardMessage
exports.LarkApiClient = require('./src/lark_api_client')
exports.Cipher = require('./src/cipher')

exports.use = (robot) ->
  config =
    api_id: process.env.LARK_API_ID
    api_secret: process.env.LARK_API_SECRET
    encrypt_key: process.env.LARK_ENCRYPT_KEY
    port: process.env.LARK_BOT_PORT

  new LarkBot robot, config
