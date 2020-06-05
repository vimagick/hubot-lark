(function() {
  var Cipher, crypto;

  crypto = require('crypto');

  // cipher = new Cipher("your key")
  // encrypted = cipher.encrypt("hello")
  // decrypted = cipher.decrypt(encrypted)

  Cipher = class Cipher {
    constructor(key) {
      this.key = crypto.createHash('sha256').update(key).digest();
    }

    encrypt(message) {
      var cipher, iv;
      iv = crypto.randomBytes(16);
      cipher = crypto.createCipheriv('aes-256-cbc', this.key, iv);
      cipher.encrypt;
      return Buffer.concat([iv, cipher.update(message), cipher.final()]).toString("base64");
    }

    decrypt(base64Message) {
      var decipher, decrypted, iv, message, msg;
      message = Buffer.from(base64Message, "base64");
      iv = message.slice(0, 16);
      msg = message.slice(16);
      decipher = crypto.createDecipheriv('aes-256-cbc', this.key, iv);
      decrypted = decipher.update(msg);
      return decrypted.toString() + decipher.final();
    }

  };

}).call(this);


//# sourceMappingURL=cipher.js.map
//# sourceURL=coffeescript