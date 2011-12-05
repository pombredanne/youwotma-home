#!/usr/bin/env node

var http = require("http"),
    WebSocket = require('websocket-client').WebSocket;

//chrome.exe --remote-debugging-port=9222

var options = {
  host: 'localhost',
  port: 9222,
  path: '/json'
};

http.get(options, function(res) {
    var data = "";
    res.on("data",function(c){
        data += c;
    });
    res.on("end",function(){
        var url = JSON.parse(data)[0]["webSocketDebuggerUrl"];
        //console.log(data);
        var ws = new WebSocket(url);
        var send = true;
        ws.onmessage = function(m) {
            //console.log('Got message: ' , m);
            send && ws.send('{"method":"Runtime.evaluate","params":{"expression":"location.href=location.href;","objectGroup":"console","includeCommandLineAPI":true},"id":101}');
            send = false;
            process.exit(code=0);
        }
        ws.onerror = function(e){console.error(e);}
    });
}).on('error', function(e) {
  console.log("Got error: " + e.message);
});
