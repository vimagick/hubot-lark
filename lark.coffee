LarkBot = require './src/bot'

exports.LarkImageMessage = require('./src/message').LarkImageMessage
exports.LarkCardMessage = require('./src/message').LarkCardMessage
exports.LarkApiClient = require('./src/lark_api_client')

exports.use = (robot) ->
  options =
    api_id: process.env.LARK_API_ID
    api_secret: process.env.LARK_API_SECRET
    encrypt_key: process.env.LARK_ENCRYPT_KEY

  new LarkBot robot, options
