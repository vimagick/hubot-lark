crypto = require('crypto')

# cipher = new Cipher("your key")
# encrypted = cipher.encrypt("hello")
# decrypted = cipher.decrypt(encrypted)
#
class Cipher
  constructor: (key) ->
    @key = crypto.createHash('sha256').update(key).digest()

  encrypt: (message) ->
    iv = crypto.randomBytes(16)
    cipher = crypto.createCipheriv('aes-256-cbc', @key, iv)
    cipher.encrypt
    return Buffer.concat([iv, cipher.update(message), cipher.final()]).toString("base64")

  decrypt: (base64Message) ->
    message = Buffer.from base64Message, "base64"
    iv = message.slice(0, 16)
    msg = message.slice(16)

    decipher = crypto.createDecipheriv('aes-256-cbc', @key, iv)
    decrypted = decipher.update(msg)
    return decrypted.toString() + decipher.final()
