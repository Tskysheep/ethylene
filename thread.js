.pragma library

WorkerScript.onMessage = function(message){
    //
    console.log("i am in")
    message.ut.uts.test()
    WorkerScript.sendMessage({})
}
