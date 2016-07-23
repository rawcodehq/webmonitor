var adapterFor = (function() {
  var url = require('url'),
    adapters = {
      'http:': require('http'),
      'https:': require('https'),
    };

  return function(inputUrl) {
    return adapters[url.parse(inputUrl).protocol];
  };
}());

var timeoutMS = process.env.NODE_ENV === "test" ? 1 * 1000 : 10 * 1000;

function request(url, responseCallback, errorCallback) {
  var adapter = adapterFor(url),
    req = adapter.request(url, responseCallback);

  req.on('socket', function(socket) {
    socket.setTimeout(timeoutMS);
    socket.on('timeout', function() {
      req.abort();
    });
  });

  req.end();
  return req;
}

function formatErrorMessage(e){
  return "CODE: " + (e.code || "") + "|" +  "MESSAGE: " + (e.message || "");
}
function translateHttpError(e){
  if (e.syscall === 'getaddrinfo' && e.code == 'ENOTFOUND') {
    return {status: 'down', error: "Unable to resolve domain"};
  }

  return {status: 'down', error: 'UNKNOWN'}
}

// helper function
function checkUrl(url, callback) {
  var startAt = new Date(),
    elapsedTime = function() {
      return (new Date()) - startAt;
    }


  try {
    var req = request(url, function(res) {
      var status = res.statusCode;

      // do something with this later
      var body = '';
      res.on('data', function(d) {
        body += d;
      });

      // successful
      res.on('end', function() {
        callback({
          status: status,
          response_time_ms: elapsedTime()
        });
      });

    });

    // error from the http lib
    // most probably means the site is down
    req.on('error', function(e) {
      var err = translateHttpError(e); // returns a {status: .., error: ..}
      callback({
        status: err.status,
        error: err.error,
        message: formatErrorMessage(e),
        response_time_ms: elapsedTime()
      })
    })
  } catch (e) {
    callback({
      status: "error",
      error: e.message,
      response_time_ms: elapsedTime()
    });
  }
}


exports.handler = function(event, context, callback) {
  checkUrl(event.url, function(response) {
    callback(null, response)
  })
};
