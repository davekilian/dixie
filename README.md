
Dixie
=====

Dixie is a Dropbox-powered wiki. It uses a folder on your Dropbox for storage
and lets your author wiki pages using a mixture of Markdown for text and
LaTeX for math. Sharing a wiki is as easy as sharing a folder from Dropbox,
and your wiki's content never leaves your hands.

[Try Dixie Now](http://dixie.heroku.com) (requires a free 
[Dropbox account](http://www.dropbox.com)).

Wiki Structure
--------------

Dixie supports multiple logically-separated wikis. Individual wikis follow
Mediawiki-style conventions:

* There is no limit on the number of wikis a user can have, beyond storage
  limits in the user's Dropbox account. Every wiki has a unique name.
* Each wiki contains pages with unique titles. There is no hierarchy between
  wiki pages.
* New pages are added by first editing an existing page to link to the
  new (noneistent) page. Clicking this link allows the user to edit the page,
  creating it upon saving it.
* Multimedia attachments can be stored and linked to within the wiki. Users
  can also embed external resources.

Dropbox Integration
-------------------

Dixie is sandboxed to a folder on your Dropbox via an
[app folder](https://www.dropbox.com/developers/start/core). Pages are stored
in raw markdown, and any direct modification to these files are immediately
reflected on the website (after the changes are synced with the cloud). 

Each wiki is represented by a folder in Dixie's app folder. This folder 
contains the pages in the wiki ('page-name.md') and an uploads/ folder
contained media uploaded to and used within the wiki.

