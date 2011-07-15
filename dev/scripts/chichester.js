var http = require('http');
var puts = require("sys").puts;

var aliases = {};

require("fs").readFileSync("aliases","utf-8").split("\n").forEach(function(line){
    line = line.split(":");
    aliases[line[0]] = line[1];
});

http.createServer(function (req, res){
    var host = aliases[req.headers["host"]];
    delete req.headers["host"];
    delete req.headers["referer"];
    var mreq = http.request({
        "method":req.method,
        "host":host,
        "port":80,
        "path": req.url,
        "headers":req.headers
    }, function(mres) {
        mres.on("end",function(){
            res.end();
        });
        mres.on("data",function(chunk){
            res.write(chunk)
        });
        res.writeHead(mres.statusCode,mres.headers);
    });
    req.on("data",function(chunk){
        mreq.write(chunk);
    });
    req.on("end",function(chunk){
        mreq.end();
    });
}).listen(80,"127.0.0.1");
