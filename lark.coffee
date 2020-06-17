LarkBot = require './src/bot'

exports.use = (robot) ->
  options =
    api_id: process.env.LARK_API_ID
    api_secret: process.env.LARK_API_SECRET
    encrypt_key: process.env.LARK_ENCRYPT_KEY

  new LarkBot robot, options
