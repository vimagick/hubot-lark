LarkBot = require './src/bot'

exports.use = (robot) ->
  options =
    api_id: process.env.LARK_API_ID
    api_secret: process.env.LARK_API_SECRET
    encrypt_key: process.env.LARK_ENCRYPT_KEY
    port: process.env.LARK_BOT_PORT || "9090"

  new LarkBot robot, options
