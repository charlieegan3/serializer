#serializer

[![Build Status](https://travis-ci.org/charlieegan3/serializer.svg?branch=master)](https://travis-ci.org/charlieegan3/serializer)
[![Code Climate](https://codeclimate.com/github/charlieegan3/serializer/badges/gpa.svg)](https://codeclimate.com/github/charlieegan3/serializer)
[![Test Coverage](https://codeclimate.com/github/charlieegan3/serializer/badges/coverage.svg)](https://codeclimate.com/github/charlieegan3/serializer/coverage)

serializer collects links from Hacker news, Reddit & Product Hunt and lists them in **sequential** order, some might even say it serializes them. It now collects quite a few other sources as well.

I deploy the app to [serializer.io](http://www.serializer.io) every few days. It's currently configured to work with [dokku-alt](https://github.com/dokku-alt/dokku-alt). [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler) is used to run the collect tasks.

##Features
* Read-to-Here Marker
* **Loginless** sessions for cross-device syncing
* Customizable source feeds - I follow [/all](http://www.serializer.io/all)
* Reading time estimates (based on 300wpm and a simple content extractor)
* Tweet counts that are updated for recently added items
* Basic duplicate link removal
* Tab title unread marker & background refresh

##Feedback & Contributing
I'm keen to accept changes that make serializer work better for you, pull requests welcome. If something's not right [open an issue](https://github.com/charlieegan3/serializer/issues/new). There's an anonymous feedback form [here](https://charlie43.typeform.com/to/tZWtCn).

####Notes
* `rake collect_active` & `rake collect_feeds` can be used to populate items, collection doesn't run automatically in development.
* Images and icons are hosted on [Cloudinary](https://cloudinary.com/users/register/free), it's super easy to get setup with a free account there.
* If the app errors in collection it sends notifications using the [Gmail gem](https://github.com/gmailgem/gmail)

######ENV
* `NOTIFY_EMAIL` where errors emails should be sent
* `GMAIL_ACCOUNT` & `GMAIL_PASSWORD` Gmail login for notification sender account
* `CLOUD_NAME`, `CLOUDINARY_KEY` & `CLOUDINARY_SECRET` Cloudinary credentials
* `TRELLO_KEY` Take a look around, you might find some hidden features.

