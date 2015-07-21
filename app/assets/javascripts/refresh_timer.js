function refreshPage() {
  if(!document.hasFocus()) { location.reload(); }
}

setInterval(refreshPage, 120000);
