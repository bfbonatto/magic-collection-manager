var express = require('express');
var app = express();
var server = require('http').Server(app); 
var io = require('socket.io')(server);
var fs = require("fs");



app.use(express.static('client'))


app.get('/index.html', function (req, res) {
	res.sendFile( __dirname + "/client/" + "index.html" );
})
app.post('/process_post',function (req,res) {
	//res.sendfile( __dirname + "/client/" + "index.html" );
})

io.on("connection",function(client){
	console.log("connected");
	client.on("save",function(data,username) {
		console.log("saving...")
		console.log(data);
		console.log(username)
		fs.writeFile(username+".txt",data);
	})
	
	client.on("load",function(username){
		console.log("loading...")
		console.log(username)
		fs.readFile(username+".txt",function(err,data){
			if(err){
				console.error(err);
			}
			console.log(data.toString());
			client.emit("return_load",data.toString());
		})
	})
	
})



server.listen(process.env.PORT, process.env.IP, function () {
	var host = server.address().address
	var port = server.address().port
	
	console.log("Example app listening at https://%s:%s/index.html", host, port)

})

