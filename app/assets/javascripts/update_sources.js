function highlightButtons(session) {
  var selectedSources = session.sources;
  var toggleButtons = document.getElementsByClassName('source-toggle');

  for(var i = 0; i < toggleButtons.length; i++) {
    var button = toggleButtons[i];
    if (selectedSources.length === 0) {
      button.className = 'source-toggle';
    }
    for(var j = 0; j < selectedSources.length; j++) {
      if (selectedSources[j] === button.attributes.data.value) {
        button.className = 'source-toggle enabled';
        break;
      } else {
        button.className = 'source-toggle';
      }
    }
  }
}

DOMReady(function () {
  getSession(function(result) {
    highlightButtons(result.session);
  });

  var toggleButtons = document.getElementsByClassName('source-toggle');
  for(var i = 0; i < toggleButtons.length; i++) {
    toggleButtons[i].onclick = function(e) {
      var el = e.target;

      var request = new XMLHttpRequest();
      request.open('POST', '/add_source', true);
      request.onload = function() {
        if (request.status === 200) {
          highlightButtons(JSON.parse(request.response));
          getSession(function(result){
            drawItemList(result);
          });
        }
      };
      request.send(JSON.stringify({ source: el.parentNode.attributes.data.value.toString() }));
    }
  }
});
