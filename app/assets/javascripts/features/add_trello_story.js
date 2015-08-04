function setTrelloSaveButtons(session) {
  saveButtons = document.getElementsByClassName('save-button');
  if (session.trello_token === null) {
    while(saveButtons[0]) {
      saveButtons[0].parentNode.parentNode.removeChild(saveButtons[0].parentNode);
    }
  } else {
    for(var i = 0; i < saveButtons.length; i++) {
      itemId = parseInt(saveButtons[i].attributes.data.value);

      if (session.saved_items.indexOf(itemId) > -1) {
        saveButtons[i].parentNode.style.display = "none";
        continue;
      }

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
  }
};
