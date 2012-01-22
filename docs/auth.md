
Dropbox Authentication
======================

Design (UX, helper module) for handling Dropbox authentication integration.
This builds off my experiences writing a Dropbox + rails prototype app.

User Experience
---------------

The static pages (e.g. about, contact, privacy policy) can be viewed whether
or not the user is linked to a Dropbox account. 

When the user is linked, the site works as described in urls.md.

When no account is linked, the user goes through a three-step process:

* The user is shown a _setup_ page describing why the application is unable
  to complete the request. This page contains a Dropbox auth link. Different
  scenarios may use different setup pages.
* The user, upon clicking the auth link, is directed to the standard
  Dropbox app authentication link for Dixie
* If the user allowed the app to link, the action originally requested is now
  run to _completion_, optionally with the addition of a flash message to 
  denote successful linkage.
* If the application is not authorized to link with the Dropbox account, a
  _reset_ page is shown.

### Scenarios

1. The user requests the home page
   * Setup: The home page contains a logo, teaser text, an about page link,
     and a link to Dropbox link.
   * Completion: The user is redirected to the main page of the default wiki,
     which gives some basic information and links for more help
   * Reset: The user is shown the setup, with a flash explaining that the user
     did not allow the app to access the account or that a Dropbox integration
     error occured. Three actions: Try Again | Report an Error | Close
2. The user requests what appears to be a wiki page
   * Setup: The page looks the same as regular wiki pages, but the contents
     consist of a link along the lines of "Link my Dropbox account and create
     a wiki called 'thing-I-parsed-from-url'"
   * Completion: user is directed to the create-a-wiki wizard. The name is
     already filled in. This is done by taking the wiki name from the URL,
     replacing '-' characters with spaces, and capitalizing each word. A 
     flash message also links to the main page of the default wiki
   * Reset: The Setup page, with the same flash as in the home page scenario
3. The user views a public wiki
   * Setup: Somewhere out of the way, text along the lines of 'Username is
     using [Dixie](link-to-homepage) to share this wiki. [Get started now]
     (Link to Dropbox link)'. Reset of the page is the wiki page as would be
     visible if the current user were linked
   * Completion: The same page, but the teaser text has been replaced with a
     link describing how to share your own pages. A flash message directs the
     user to the main page of the default wiki
   * Reset: The setup page with that fancy flash thing. Starting to see a
     pattern here?
4. The user reads the about page
   * Setup: The about page, containing a get started now link
   * Completion: The same as the completion for the home page
   * Reset: The same flash error message, but on its own stark page. Links are
     Try Again | Report an Error | Back to Home Page

Implementation
--------------

See dribble.md

