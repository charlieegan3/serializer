function readToRow(session, unreadCount) {
  if (unreadCount == 0) {
    var message = 'All Marked as Read - ';
  } else {
    var message = 'Read to Here - ';
  }
  return createElementWithAttributes('TR', {}, [
    createElementWithAttributes('TD', { 'class': 'log', 'colspan': 2 }, [
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

function drawItemList(data, thing) {
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
    itemTable.parentNode.insertBefore(
      markButton(data),
      itemTable
    );
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
}

DOMReady(function () {
  var request = new XMLHttpRequest();
  request.open('GET', '/session', true);
  request.onload = function() {
    if (request.status === 200) {
      drawItemList(JSON.parse(request.responseText), true);
    };
  };
  request.onerror = function() {

  };
  request.send();
});
