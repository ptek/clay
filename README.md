## About

Clay generates static pages using layouts and text snippets. It is something like a CMS for those who know html and would like to use their own text editor. Clay was inspired by [jekyll](http://jekyllrb.com/) which is a simple tool to create a blog. The difference between clay and jekyll is that clay aims at a clear folder structure and simple templating using [mustache](http://mustache.github.com/). 

There are plans for adding a blogging support in clay too.

## Getting started

* Start by installing the [gem](https://rubygems.org/gems/clay)
        gem install clay
* Init your project using clay
        clay init <project name>
* Create layouts/default.html in the project directory with the following content:
        <html>
          <title>{{title}}</title>
          <body>{{{content}}}</body>
        </html>
* Create pages/index.html in the project directory
        ---
        title: Home
        ---
        <h1>Hello from clay</h1>
* run 
        clay form && clay run
* Preview Your site on http://localhost:9292 or publish it via FTP. 
  When publishing, You should take only the files in the build folder

## Howto

In your project directory You will find following subdirectories

* layouts
* pages
* public
   
The _layouts_ directory is for the global layouts of your pages. 
There must be a layout called default.html
	 
In the _pages_ directory You create each page You want to have.
The pages are created in html or markdown.
The filename of an html page must be <pagename>.html 
Markdown pages however can be either <pagename>.md or <pagename>.markdown
	 
*NOTE* Your pages may have any names You want. However given your domain 
name is foo.com, and You want that the main page shows up at http://foo.com
You will have to create page named index in the pages directory

----------------------------------------

## Licence

[Clay](https://github.com/kerestey/clay) by [Pavlo Kerestey](http://kerestey.net) is licensed under a [MIT Licence](http://creativecommons.org/licenses/MIT/). Permissions beyond the scope of this license may be available at <a xmlns:cc="http://creativecommons.org/ns#" href="http://kerestey.net" rel="cc:morePermissions">http://kerestey.net</a>.

## Full text of the licence

    Copyright (C) 2011 by Pavlo Kerestey

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
