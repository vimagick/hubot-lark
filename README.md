# Setup Hubot Lark

1. Install

```
npm install hubot-lark --save
```

2. You need pass below environment variables to your hubot.

```
export LARK_API_ID=xxxxxx
export LARK_API_SECRET=xxxxxx
export LARK_ENCRYPT_KEY=xxxxxx
export LARK_BOT_PORT=9090
```

3. Start your service

```
bin/hubot -a lark
```

4. Go to open.feishu.cn and setup your bot's Event Subscription Request URL to below address

```
http://YOUR-SITE-DOMAIN:LARK_BOT_PORT/lark-integration
```

# How to send a message by Hubot

```
robot.respond /hello/i, (msg) ->
  msg.send "Hi how are you."
```

# How to send a message by API

```
{ LarkApiClient } = require 'hubot-lark'
larkClient = new LarkApiClient(process.env.LARK_API_ID, process.env.LARK_API_SECRET)
larkClient.messageDirectSend(MESSAGE_JSON)
```

Message JSON structure:

https://open.feishu.cn/document/ukTMukTMukTM/uUjNz4SN2MjL1YzM

# How to send a card message

```
robot.respond /hello/i, (msg) ->
  message = new LarkCardMessage({
    color: "blue",
    title: YOUR TITLE,
    extraBody: {
      tag: "img",
      img_key: IMAGE KEY,
      alt: {
        tag: "plain_text",
        content: CONTENT LINK
      }
    },
    buttons: [
      {
        tag: "button",
        text: {
          tag: "lark_md",
          content: "BUTTON TEXT"
        },
        url: link,
        type: "default"
      }
    ]
  })
  msg.send message
```
