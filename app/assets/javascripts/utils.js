var DOMReady = function(a,b,c){b=document,c='addEventListener';b[c]?b[c]('DOMContentLoaded',a):window.attachEvent('onload',a)}

function setAttributes(element, attributes) {
  for(var key in attributes) {
    element.setAttribute(key, attributes[key]);
  }
}

function createElementWithAttributes(type, attributes, children) {
  children = typeof children !== 'undefined' ? children : [];

  element = document.createElement(type);
  setAttributes(element, attributes);
  for(var index = 0; index < children.length; ++index) {
    element.appendChild(children[index]);
  }
  return element;
}

function shortURL(url) {
  try {
    url = url.toLowerCase().replace(/^https?/i, '').replace(/www\./, '').replace(/^\W+/, '');

    if (url.indexOf('/') != -1) {
      url = url.split('/')[0]
    } else {
      url = url.substring(0, 100)
    }

    return url.replace(/[^\w\.]/, '');
  }
  catch(err) {
    return url;
  }
}

function readingTime(wordCount) {
  return Math.ceil(wordCount / 300).toString() + 'm read';
}

function readingTimeClass(wordCount) {
  if (wordCount < 1500) {
    return 'fast';
  } else if (wordCount < 3000) {
    return 'medium';
  } else {
    return 'slow';
  }
}

function setCookie(cname, cvalue, exdays) {
  var d = new Date();
  d.setTime(d.getTime() + (exdays*24*60*60*1000));
  var expires = "expires="+d.toUTCString();
  document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(cname) {
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i=0; i<ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0)==' ') c = c.substring(1);
      if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
  }
  return "";
}
