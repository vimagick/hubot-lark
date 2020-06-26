Cipher = require "./cipher"
axios = require 'axios'

TOKEN_ERROR_CODES = ['99991661', '99991663', '99991665']

# TODO seems all the request is the same, like mostly just GET/POST with different PATH
# LarkApiClient().message.directSend(payload)
class Message
  directSend: (payload) ->
    axios.post("message/v4/send", payload)
      .then (resp) ->
        console.log resp.data
      .catch (err) ->
        console.log "Got some error when directSend msg to lark"
        console.log err.response.data

  batchSend: (payload) ->
    axios.post("message/v4/batch_send", payload)
      .then (resp) ->
        console.log resp.data
      .catch (err) ->
        console.log "Got some error when batchSend msg to lark"
        console.log err.response.data

class LarkApiClient
  constructor: (@appId, @appSecret) ->
    # settings
    @configAxios()
    @token = null

    # submodules
    @message = new Message

  configAxios: ->
    axios.defaults.baseURL = 'https://open.feishu.cn/open-apis'
    axios.defaults.headers.common['Content-Type'] = 'application/json'

    # response interceptor
    interceptor = axios.interceptors.response.use(
      (response) =>
        return response
      (error) =>
        if TOKEN_ERROR_CODES.includes String(error.response.data.code)
          axios.interceptors.response.eject interceptor
          @auth()
            .then (resp) ->
              error.config.headers["Authorization"] = "Bearer #{@token}"
              axios.request(error.config)
            .catch (err) ->
              Promise.reject(err)
        else
          return Promise.reject(error)
    )

  auth: ->
    axios.post("auth/v3/tenant_access_token/internal", {
      app_id: @appId,
      app_secret: @appSecret
    })
      .then (resp) ->
        @token = resp.data.tenant_access_token
      .catch (err) ->
        console.log "Got some error during get tenant access token: #{err}"

module.exports = LarkApiClient
