/**
 * author: ptrjeffrey
 *  date: 2022-03-01
 * discription: tool assist
 */
 const _ = require('underscore')
 const botname = "@_user_1"
 
 module.exports = {
     parseMessage : function(res) {
         let ret = {}
         console.log('--------------------------')
        //  console.log(res)
         ret.userName = res.envelope.user.name || ''
         const J = JSON.parse(res.message.text)
         let list = J.text.split(" ")
         let idx = list.indexOf(botname)
         idx =  idx < 0 ? 0 : idx + 1
         list = list.slice(idx)
 
        //  console.log(list)
        //  console.log(res.message.text)
         
         let lst = []
         let str = ''
         if (list.length >= 2 && list[0] === botname){
             lst = list.slice(1)
             ret.command = list[1]
             if(list.length > 2){
                 ret.params = list.slice(2)
             }
         }else{
             lst = list
             ret.command = list[0]
             if(list.length > 1) {
                 ret.params = list.slice(1)
             }
         }
         for(let c of lst){
             str += c + " "
         }
     
         ret.text = res.message.text
         return ret
     },
     sleep: async function (ms){
         return new Promise((resolve) => {
             setTimeout(() => {
                 resolve()
             }, ms)
         })
     }
 }
 