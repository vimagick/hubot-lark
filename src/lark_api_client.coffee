Cipher = require "./cipher"
axios = require 'axios'
_ = require 'lodash'

TOKEN_ERROR_CODES = ['99991661', '99991663', '99991665']
LARK_URL = process.env.LARK_URL || 'https://open.feishu.cn/open-apis'

# TODO seems all the request is the same, like mostly just GET/POST with different PATH
# LarkApiClient().messageDirectSend(payload)
class LarkApiClient
  constructor: (@appId, @appSecret) ->
    axios.defaults.baseURL = LARK_URL
    axios.defaults.headers.common['Content-Type'] = 'application/json'

  auth: ->
    axios.post("auth/v3/tenant_access_token/internal", {
      app_id: @appId,
      app_secret: @appSecret
    })
      .then (resp) =>
        token = resp.data.tenant_access_token
        if token?
          token
        else
          Promise.reject resp.data
      .catch (err) =>
        console.log "Got some error during get tenant access token: "
        console.log err

  messageFetch: (mid) ->
    @auth()
      .then (token) ->
        axios.get("im/v1/messages/#{mid}", {
          headers: { Authorization: "Bearer #{token}" }
        })
        .then (resp) ->
          if resp.data.code != 0
            Promise.reject resp
          else
            console.log "fetch success"
            resp
        .catch (err) ->
          console.log "fetch fail"
          console.log err.data

  messageDirectSend: (payload) ->
    @auth()
      .then (token) ->
        axios.post("message/v4/send", payload, {
          headers: { Authorization: "Bearer #{token}" }
        })
        .then (resp) ->
          if resp.data.code != 0
            Promise.reject resp
          else
            console.log "direct send success"
            resp
        .catch (err) ->
          console.log "direct send fail"
          console.log err.data

  messageBatchSend: (payload) ->
    @auth()
      .then (token) ->
        axios.post("message/v4/batch_send", payload, {
          headers: { Authorization: "Bearer #{token}" }
        })
        .then (resp) ->
          if resp.data.code != 0
            Promise.reject resp
          else
            console.log "batch send success"
            resp
        .catch (err) ->
          console.log "batch send fail"
          console.log err.data

  imagePut: (form) ->
    @auth()
      .then (token) ->
        axios({
          method: 'post',
          url: 'image/v4/put',
          headers: _.merge({ Authorization: "Bearer #{token}" }, form.getHeaders()),
          data : form
        })
        .then (resp) ->
          if resp.data.code != 0
            Promise.reject resp
          else
            console.log "image put success"
            resp
        .catch (err) ->
          console.log "image put fail"
          console.log err.data

module.exports = LarkApiClient
