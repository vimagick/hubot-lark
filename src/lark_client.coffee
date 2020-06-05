Cipher = require "./cipher"
axios = require 'axios'

axios.defaults.baseURL = 'https://open.feishu.cn/open-apis'
axios.defaults.headers.post['Content-Type'] = 'application/json'

class Message
  directSend: (payload) ->
    axios.post("message/v4/send", payload)
      .then (resp) ->
        console.log resp.data
      .catch (err) ->
        console.log err

class LarkClient
  constructor: (@appId, @appSecret) ->
    @message = new Message(@)

  auth: ->
    axios.post("auth/v3/tenant_access_token/internal",{
      app_id: @appId,
      app_secret: @appSecret
    })
      .then (resp) ->
        axios.defaults.headers.common['Authorization'] = "Bearer #{resp.data.tenant_access_token}"
      .catch (err) ->
        console.log "Got some error during get tenant access token: #{err}"

module.exports = LarkClient
