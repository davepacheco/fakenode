var http = require('http');

http.get({
	port: 1337,
	path: '/' + process.argv.slice(2).join('/'),
	agent: false
}, function (response) {
	console.log('status: ' + response.statusCode);
});
