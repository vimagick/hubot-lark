const _ = require('underscore')

module.exports = {
  getProjectByCommand: function(command) {
    let ret = undefined
    for(let p of _(this.Project).keys() ) {
      if (this.Project[p].cmd === command) {
        ret = p
        break
      }
    }
    return ret
  },
  // add your commands and help info here
  Project: {
    'ping': {
      name: 'null',
      remoteKey: 'null',
      cmd: 'ping',
      description: ['Reply with pong']
    },
    'help': {
      name: 'null',
      remoteKey: 'null',
      cmd: 'help',
      description: ['Displays all of the help commands that this bot knows about.',
      '<query> - Displays all help commands that match <query>.'
     ]
    }
  }
}