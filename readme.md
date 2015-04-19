d#serializer

The code that runs [serializer.io](http://www.serializer.io). serializer collects links from Hacker news, Reddit & Product Hunt and lists them in **sequential** order, some might even say it serializes them...

##Features
* Read-to-Here Marker
* Sessions for cross-device syncing (without user login)
* Customizable source feeds for users who aren’t me (I follow [/all](http://www.serializer.io))
* Reading time estimates (based on 300wpm and a simple content extractor)
* Tweet counts for recently added items
* Basic duplicate link removal

##Contributing
Fork, PR etc. I'm keen to accept changes that make serializer better for you, just as long as they don't make it worse for me! If you're looking you'd like something to work on then take a look at the todo list below.

###Notes
* The app is setup to be deployed to dokku, but it ought to be easy enough to spin up on Heroku since that's how I originally hosted it.
* `rake collect_active` & `rake collect_feeds` can be used to populate news stories.

##Todo
* Trello OAuth, at the moment users need to copy and paste a token back into the form to link to Trello as a reading list.
 
Please do open issues if you'd like to make a suggestion.
