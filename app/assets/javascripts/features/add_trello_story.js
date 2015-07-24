DOMReady(function () {
  var saveButtons = document.getElementsByClassName('save-button');
  for(var i = 0; i < saveButtons.length; i++) {
    saveButtons[i].onclick = function(e) {
      var el = e.target;
      el.style.display = 'none';
      var url = '/add_trello_story/' + el.attributes.data.value;

      var request = new XMLHttpRequest();
      request.open('GET', url, true);
      request.onload = function() {
        if (request.status === 200) {
          el.parentNode.removeChild(e.target);
        } else { el.style.display = 'inline'; }
      };
      request.onerror = function() { el.style.display = 'inline'; };
      request.send();
    }
  }
});
