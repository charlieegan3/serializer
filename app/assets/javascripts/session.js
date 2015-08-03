function getSession(callback) {
  var request = new XMLHttpRequest();
  request.open('GET', '/session', true);
  request.onload = function() {
    callback(JSON.parse(request.responseText));
  };
  request.send();
}
