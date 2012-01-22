
Math in Dixie
=============

Ideally I'd like to be able to write TeX-style math markup in wiki pages.
I'm also planning on deploying to a shared hosting environment like Heroku,
so calling an external tex binary is not an option.

The goal is to convert some easy markup (TeX, similar, or simpler) to math. At
the very least it should support

* Variables
* Greek characters
* Common operators (scalar, vector)
* Parentheses, brackets, curlies
* Subscripts / superscripts
* Fractions
* Vectors / matrices
* Derivatives and integrals
* Summations

Server-side Options
-------------------

General strategies are either to create a pre-rendered static image that can
be served in place of the math or pre-convert the markup to HTML when the
document is saved.

* Convert TeX to [MathML](http://en.wikipedia.org/wiki/MathML) 
  * Only looks good in Firefox
  * Not supported in Chrome
* Convert Tex to [this](http://www.zipcon.net/~swhite/docs/math/math.html)

Client-side Options
-------------------

General strategy is to leave the markup embedded and let the browser convert
the markup to HTML

* [MathJax](http://www.mathjax.org)
* Port [Multimarkdown](https://github.com/fletcher/MultiMarkdown/wiki/MultiMarkdown-Syntax-Guide)
  to Javascript (also creates MathML)
* Roll my own (reasonable) subset of TeX math

