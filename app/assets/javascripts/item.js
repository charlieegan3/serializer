function itemIcon(item) {
  return createElementWithAttributes('TD', {}, [
    createElementWithAttributes('A', { 'href': item.url }, [
      createElementWithAttributes('IMG', {
        'class': 'icon', 'width': 20, 'height': 20,
        'src': 'http://res.cloudinary.com/charlieegan3/image/upload/' + item.source
      }, [])
    ])
  ]);
}

function itemTitle(item) {
  return createElementWithAttributes('H2', { 'class': 'item-title' }, [
    createElementWithAttributes('A', { 'href': item.url }, [
      document.createTextNode(item.title)
    ])
  ]);
}

function itemDomain(item) {
  return createElementWithAttributes('SPAN', { 'class': 'domain' }, [
    document.createTextNode(' (' + shortURL(item.url) + ')')
  ]);
}

function itemShortDomain(item) {
  return createElementWithAttributes('SPAN', { 'class': 'short-domain' }, [
    document.createTextNode(' (' + item.url + ')')
  ]);
}

function itemDetails(item) {
  var details = createElementWithAttributes('SPAN', { 'class': 'muted' }, [
    createElementWithAttributes('IMG', { 'class': 'clock-icon', 'src': 'http://res.cloudinary.com/charlieegan3/image/upload/clock.png', 'width': 10 }),

    document.createTextNode(item.age),

    createElementWithAttributes('SPAN', {}, [
      createElementWithAttributes('A', { 'href': item.comment_url }, [
        document.createTextNode('comments')
      ])
    ]),

    createElementWithAttributes('SPAN', {}, [
      createElementWithAttributes('A', { 'href': '#/', 'class': 'save-button', 'data': item.id }, [
        document.createTextNode('save')
      ])
    ]),

    createElementWithAttributes('A', { 'class': 'points', 'href': 'http://pointsapp.co/?url=' + item.url }, [
      createElementWithAttributes('SPAN', {}, [
        createElementWithAttributes('IMG', { 'src': 'http://res.cloudinary.com/charlieegan3/image/upload/points.png', 'width': 10 }),
        document.createTextNode('points')
      ])
    ]),
  ]);

  if (item.comment_url === null) {
    details.removeChild(details.childNodes[2])
  }

  if (item.tweet_count && item.tweet_count > 0) {
    details.appendChild(
      createElementWithAttributes('SPAN', {}, [
        createElementWithAttributes('IMG', { 'class': 'twitter-icon', 'width': 15, 'height': 15, 'src': 'http://res.cloudinary.com/charlieegan3/image/upload/twitter' })
      ])
    );

    details.appendChild(createElementWithAttributes('SPAN', {}, [document.createTextNode(item.tweet_count)]));
  }

  if (item.word_count && item.word_count > 150) {
    details.insertBefore(
      createElementWithAttributes('SPAN', { 'class': readingTimeClass(item.word_count) }, [document.createTextNode(readingTime(item.word_count))]),
      details.children[1]);
  }

  return details;
}

function itemSummary(item) {
  return createElementWithAttributes('TD', {}, [
    itemTitle(item),
    itemDomain(item),
    itemShortDomain(item),
    document.createElement('BR'),
    itemDetails(item)
  ])
}

function itemRow(item, rowClass) {
  return createElementWithAttributes('TR', { 'class': rowClass }, [itemIcon(item), itemSummary(item)]);
}
