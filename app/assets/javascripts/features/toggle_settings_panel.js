DOMReady(function () {
  var toggleButton = document.getElementById('settings-toggle');

  toggleButton.onclick = function() {
    var settingsPanel = document.getElementById('settings-panel');
    if (settingsPanel.className === 'hidden') {
      settingsPanel.setAttribute('class', '');
    } else {
      settingsPanel.setAttribute('class', 'hidden');
    }
  }
});
