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
