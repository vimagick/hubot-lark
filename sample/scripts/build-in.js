
const utils = require('./lib/utils')
const kConst = require('./lib/const')
const _ = require('underscore')
const _s = require('underscore.string')

async function pushMessage(ret, res, retstr) {
  return new Promise(async(resolve) => {
      res.send(retstr)
      resolve()
  })
  .catch()    
}

async function showHelp(params){
  let retstr = ''
  let filter = ''
  if(Array.isArray(params) && params.length > 0) {
    filter = params[0]
  }
  for(let p in kConst.Project) {
    if (kConst.Project[p].description && kConst.Project[p].cmd 
      && _s(kConst.Project[p].cmd).contains(filter)) {
      for( let str of kConst.Project[p].description) {
        retstr += '\n' + kConst.Project[p].cmd + " " + str ;
      }
    }
  }
  // console.log(retstr)
  return retstr;
}
async function handleCommand(res) {
  // console.log(res)
  const ret = utils.parseMessage(res)
  // console.log(ret)

  let str =  'no idea'
  if(ret.command === 'help') {
    str = await showHelp(ret.params);
  }
  const cmdList = {
   'ping': {cmd: /ping/i, project: 'test', retstr: 'pong'},
    'help': {cmd: /help/i, project: 'test', retstr: str},
  }
  await pushMessage(ret, res, cmdList[ret.command].retstr)
}

async function bot(robot) {
  let cmdList = [
    {cmd: /ping/i, project: 'test'},
    {cmd: /help/i, project: 'test'},
  ]
  for (const item of cmdList) {
    robot.hear(item.cmd, async function(res) {
      handleCommand(res)
    })
  }
}

module.exports = bot;