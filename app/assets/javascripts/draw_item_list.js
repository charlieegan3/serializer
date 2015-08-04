function readToRow(session, unreadCount) {
  if (unreadCount == 0) {
    var message = 'All Marked as Read - ';
  } else {
    var message = 'Read to Here - ';
  }
  return createElementWithAttributes('TR', {}, [
    createElementWithAttributes('TD', { 'class': 'read-marker', 'colspan': 2 }, [
      createElementWithAttributes('SPAN', {}, [document.createTextNode('✓ ')]),
      document.createTextNode(message + session.completed_to_human + ' ago')
    ])
  ]);
}

function markButton(data) {
  var button = createElementWithAttributes('A', {
    'id': 'log-button',
    'href': '#/',
    'data': data.items.unread[0].created_at
  }, [
    createElementWithAttributes('SPAN', { 'class': 'tick' }, [
      document.createTextNode('✓ ')
    ]),
    createElementWithAttributes('SPAN', { 'class': 'message' }, [
      document.createTextNode('Mark all as read')
    ])
  ]);

  button.onclick = function () {
    updateSession(button, data.session);
  }

  return button;
}

function drawItemList(data) {
  var itemTable = document.getElementById('item-table');
  if (!itemTable) { return; }
  tbody = itemTable.children[0];
  tbody.innerHTML = '';

  var logButton = document.getElementById('log-button');
  if (logButton) {
    logButton.parentNode.removeChild(logButton);
  }

  unread = data.items.unread;
  read = data.items.read;

  if (unread.length > 0) {
    document.title = "serializer - " + unread.length.toString();
    itemTable.parentNode.insertBefore(
      markButton(data),
      itemTable
    );
  } else {
    document.title = "serializer";
  }
  for (var index = 0; index < unread.length; ++index) {
    tbody.appendChild(itemRow(unread[index]));
  }

  if (read.length > 0) {
    tbody.appendChild(readToRow(data.session, data.items.unread.length));
  }

  for (var index = 0; index < read.length; ++index) {
    tbody.appendChild(itemRow(read[index], 'read'));
  }

  if (data.session.trello_token === null) {
    saveButtons = document.getElementsByClassName('save-button');
    while(saveButtons[0]) {
      saveButtons[0].parentNode.parentNode.removeChild(saveButtons[0].parentNode);
    }
  }
}

DOMReady(function () {
  getSession(function(result) {
    drawItemList(result);
  });
});
