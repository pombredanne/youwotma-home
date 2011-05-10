

var file = process.argv[2];
var json = require("fs").readFileSync(file);
var obj = JSON.parse(json);
require("sys").puts(obj.upload.links.original);
