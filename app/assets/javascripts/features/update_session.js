function updateSession(e, session) {
  e.style.display = 'hidden';
  var url = '/log?time=' + e.attributes.data.value;

  var request = new XMLHttpRequest();
  request.open('GET', url, true);
  request.onload = function() {
    if (request.status === 200) {
      e.style.display = 'none';
      drawItemList(JSON.parse(request.responseText), false);
    } else {
      e.style.display = 'block';
    }
  };
  request.onerror = function() {
    e.style.display = 'block';
  };
  request.send();
}
