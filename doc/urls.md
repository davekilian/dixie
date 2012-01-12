
URL Structure
=============

This document briefly describes dixie pages and details the URL structure

http://dixie/wiki-name/page-name/action
---------------------------------------

* **http://dixie** is the domain name (e.g. **http://dixie.heroku.com**)
* **/wiki-name** is the name of the wiki to be read. Each wiki is identified
  uniquely by its title; this part of the url contains the title converted
  to lower case, with all non-alphanumeric chracters converted to hyphens
  ('-')
  * If this and the rest of the URL is omitted, the user receives a page with
    a list of available wikis, plus links for managing those wikis and adding
    new ones
* **/page-name** is the name of the wiki page to look up. Like Mediawiki,
  there is no hierarchy to wiki pages: instead, each is identified uniquely
  by its page title. This contains the page title encoded the same way as
  **/wiki-name** above.
  * If this and the rest of the URL is omitted, the user is redirected to
    **http://domain/wiki-name/main-page**
* **/action** is action to perform with this page, one of the following:
  * **/show** or ommited: renders the page to HTML and provides edit links.
  * **/src**: shows the markdown source as plain text
  * **/edit**: displays the editor preloaded with the contents of the page,
    alongside a live preview of the changes made. 
  * **/share**: Allows the user to share the page via a public dropbox link,
    either bare or via dixie, or to export it to different formats 
  * **/save**: Post target to finish editing the page
  * **/delete**: Post target for removing the page

### Sections ###

* If the current action is **/show** or omitted, anchor tag with the section
  name may be appended to the end of the current URL (e.g. 
  **http://dixie/wiki/page/show#section-name). **section-name** is encoded
  the same way as **wiki-name** and **page-name**, and the HTML elements
  for section titles are given IDs that allow the browser to jump to the
  section using the anchor tag on its own (i.e. without javascript-based
  help or something)
* If the current action is **/edit**, **/section-name** may be appended to
  the URL (e.g. **http://dixie/wiki/page/edit#section**) to specify the
  editor should only display and update that section (and its subsections).
  The section name is encoded the same way as with the **/show** anchor
  tags above.
  * When the user is finished editing **http://dixie/wiki/page/edit/section**,
    the browser sends a POST to **http://dixie/wiki/page/save/section**

Special pages
-------------

The following pages are not related to viewing and editing wiki pages. No wiki
may be named such that its URL would conflict with one of these.

* **/search?q=query+string&wiki=my-wiki**: Searches page titles and contents
  for pages in a certain wiki or all available wikis if no **wiki=** argument 
  is specified. If the **q=** argument is specified, the search box is
  preloaded with the query and results are displayed. Otherwise an empty
  search box is displayed with no results.
* **/manage**: displays a list of available wikis, their sources (from this
  dropbox or shared from another), and allows the user to import, export,
  create, view, and delete wikis. This view is rendered implicitly when the
  user visits **http://dixie/wiki-name** without specifying a page
* **/wiki/uploads**: lists files that have been uploaded to the specified
  wiki, with options for replacing or deleting them.
* **/wiki/upload/asset-name**: POST target to store the uploaded data as
  **asset-name** filed under the wiki named **wiki**. 
* **/new**: displays a wizard/form thing for creating a new wiki
* **/wiki/share**: provides options for adding a collaborator to the wiki
* **/render?url=encoded-url**: Renders a wiki page shared from a wiki on a
  different dropbox account, and displays information about where the page
  came from. 


