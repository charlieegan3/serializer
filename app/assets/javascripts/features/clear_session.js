function deleteCookie(cookieName) {
  document.cookie = encodeURIComponent(cookieName) + "=deleted; expires=" + new Date(0).toUTCString();
}

DOMReady(function () {
  var clearButton = document.getElementById('clear-session');
    clearButton.onclick = function(e) {
      e.target.style.display = 'none';
      deleteCookie("session");
      location.reload();
    }
});
