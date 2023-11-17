Cipher = require "./cipher"
axios = require 'axios'
_ = require 'lodash'

TOKEN_ERROR_CODES = ['99991661', '99991663', '99991665']
LARK_URL = process.env.LARK_URL || 'https://open.feishu.cn/open-apis'

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

  reactionAdd: (mid, emoji) ->
    @auth()
      .then (token) ->
        axios.post("im/v1/messages/#{mid}/reactions", { reaction_type: { emoji_type: emoji }}, {
          headers: { Authorization: "Bearer #{token}" }
        })
        .then (resp) ->
          if resp.data.code != 0
            Promise.reject resp
          else
            console.log "reaction added success"
            resp
        .catch (err) ->
          console.log "reaction added fail"
          console.log err.data

  reactionRemove: (mid, rid) ->
    @auth()
      .then (token) ->
        axios.delete("im/v1/messages/#{mid}/reactions/#{rid}", {
          headers: { Authorization: "Bearer #{token}" }
        })
        .then (resp) ->
          if resp.data.code != 0
            Promise.reject resp
          else
            console.log "reaction removed success"
            resp
        .catch (err) ->
          console.log "reaction removed fail"
          console.log err.data

  reactionList: (mid) ->
    @auth()
      .then (token) ->
        axios.get("im/v1/messages/#{mid}/reactions", {
          headers: { Authorization: "Bearer #{token}" }
        })
        .then (resp) ->
          if resp.data.code != 0
            Promise.reject resp
          else
            console.log "reaction list success"
            resp
        .catch (err) ->
          console.log "reaction list fail"
          console.log err.data

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
            console.log "message fetch success"
            resp
        .catch (err) ->
          console.log "message fetch fail"
          console.log err.data

  messageReply: (mid, payload) ->
    @auth()
      .then (token) ->
        axios.post("im/v1/messages/#{mid}/reply", payload, {
          headers: { Authorization: "Bearer #{token}" }
        })
        .then (resp) ->
          if resp.data.code != 0
            Promise.reject resp
          else
            console.log "message reply success"
            resp
        .catch (err) ->
          console.log "message reply fail"
          console.log err.data

  messageSend: (payload) ->
    @auth()
      .then (token) ->
        axios.post("im/v1/messages", payload, {
          params: { receive_id_type: "chat_id" },
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

  imageUpload: (payload) ->
    @auth()
      .then (token) ->
        axios.postForm("im/v1/images", payload, {
          headers: { Authorization: "Bearer #{token}" }
        })
        .then (resp) ->
          if resp.data.code != 0
            Promise.reject resp
          else
            console.log "image upload success"
            resp
        .catch (err) ->
          console.log "image upload fail"
          console.log err.data

module.exports = LarkApiClient
