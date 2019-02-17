WorkerScript.onMessage = function(message) {
    // ... long-running operations and calculations are done here
//    WorkerScript.sendMessage({ 'reply': 'Mouse is at ' + message.x + ',' + message.y })
    console.log(message, JSON.stringify(message))
    var server = message['server']
    var currentFuranceNum = message['currentFuranceNum']
    var fromDate = message['from']
    var toDate = message['to']
    var result = server.all_tube_show( currentFuranceNum, fromDate, toDate);
    WorkerScript.sendMessage(result)
}
