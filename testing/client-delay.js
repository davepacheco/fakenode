var http = require('http');

setTimeout(function () {
	http.get({
		port: 1338,
		path: '/' + process.argv.slice(2).join('/'),
	}, function (response) {
		console.log('status: ' + response.statusCode);
	});
}, 10000);
