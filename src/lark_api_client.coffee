Cipher = require "./cipher"
axios = require 'axios'

# TODO seems all the request is the same, like mostly just GET/POST with different PATH
# LarkApiClient().message.directSend(payload)
class Message
  directSend: (payload) ->
    axios.post("message/v4/send", payload)
      .then (resp) ->
        console.log resp.data
      .catch (err) ->
        console.log err

  batchSend: (payload) ->
    axios.post("message/v4/batch_send", payload)
      .then (resp) ->
        console.log resp.data
      .catch (err) ->
        console.log err

class LarkApiClient
  constructor: (@appId, @appSecret) ->
    # settings
    axios.defaults.baseURL = 'https://open.feishu.cn/open-apis'
    axios.defaults.headers.post['Content-Type'] = 'application/json'

    # submodules
    @message = new Message

  auth: ->
    axios.post("auth/v3/tenant_access_token/internal",{
      app_id: @appId,
      app_secret: @appSecret
    })
      .then (resp) ->
        axios.defaults.headers.common['Authorization'] = "Bearer #{resp.data.tenant_access_token}"
      .catch (err) ->
        console.log "Got some error during get tenant access token: #{err}"

module.exports = LarkApiClient