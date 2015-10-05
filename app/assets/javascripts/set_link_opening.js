function updateLinkTargets(value) {
  var links = document.querySelectorAll('#item-table a');
  for(var i in links) {
    console.log(links[i].tagName);
    if (links[i].tagName != "A") {
      continue;
    }
    links[i].setAttribute('target', value);
  }
}
DOMReady(function () {
  var setLinkButton = document.getElementById("set-link-opening");
  var linkOpening = getCookie("links-open-in-new-tab");

  if (linkOpening == 1) {
    setLinkButton.innerHTML = "Open Links in Current Tab";
  } else {
    setLinkButton.innerHTML = "Open Links in New Tab";
  }

  setLinkButton.onclick = function(e) {
    var currentValue = getCookie("links-open-in-new-tab");
    if (currentValue == 1) {
      setCookie("links-open-in-new-tab", 0, 10000);
      setLinkButton.innerHTML = "Open Links in New Tab";
      updateLinkTargets("_self");
    } else {
      setCookie("links-open-in-new-tab", 1, 10000);
      setLinkButton.innerHTML = "Open Links in Current Tab";
      updateLinkTargets("_blank");
    }
  }
});
