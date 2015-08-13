function refreshPage() {
  var request = new XMLHttpRequest();
  request.open('GET', '/session', true);
  request.onload = function() {
    if (request.status === 200) {
      drawItemList(JSON.parse(request.responseText), true);
    };
  };
  request.send();
}

setInterval(refreshPage, 60000);
