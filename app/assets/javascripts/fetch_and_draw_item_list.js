function readToRow(session) {
  return createElementWithAttributes('TR', {}, [
    createElementWithAttributes('TD', { 'class': 'log', 'colspan': 2 }, [
      createElementWithAttributes('SPAN', {}, [document.createTextNode('✓ ')]),
      document.createTextNode('Read to here - ' + session.completed_to_human + ' ago')
    ])
  ]);
}

function markButton(session) {
  return createElementWithAttributes('A', {
    'class': 'log-button',
    'href': '/log?time=' + session.timestamp
  }, [
    createElementWithAttributes('SPAN', { 'class': 'tick' }, [
      document.createTextNode('✓ ')
    ]),
    createElementWithAttributes('SPAN', { 'class': 'message' }, [
      document.createTextNode('Mark all as read')
    ])
  ]);
}

DOMReady(function () {
  var itemTable = document.getElementById('item-table');
  if (!itemTable) { return; }
  tbody = itemTable.children[0];

  var request = new XMLHttpRequest();
  request.open('GET', '/session', true);
  request.onload = function() {
    if (request.status === 200) {
      var data = JSON.parse(request.responseText);

      unread = data.items.unread;
      read = data.items.read;

      if (unread.length > 0) {
        itemTable.parentNode.insertBefore(
          markButton(data.session),
          itemTable
        );
      }
      for (var index = 0; index < unread.length; ++index) {
        tbody.appendChild(itemRow(unread[index]));
      }

      tbody.appendChild(readToRow(data.session));

      for (var index = 0; index < read.length; ++index) {
        tbody.appendChild(itemRow(read[index], 'read'));
      }
    };
  };
  request.onerror = function() {

  };
  request.send();
});
