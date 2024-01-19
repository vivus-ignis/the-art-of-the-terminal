var http = require("http");

http.createServer(function (req, res) {

    res.writeHead(500, {
        "Content-Type" : "text/plain"
    });
    res.writeHead(200);
    res.write('hello world.');
    res.end();

}).listen(8888);
