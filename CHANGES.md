= 1.7 / Not released yet

* Changed the directories form _public_ to _static_ for 
  static files like css stylesheets, javascript or images...
  This Change is very important because it will allow
  users to assign the build directory to be _public_ therefore
  creating a possibility to serve the static webpages
  using passenger or nginx - faster and more reliable
  webservers.
	
* Added an option to config.yaml where one can specify
  the build target directory. This directory will be the
  one where the built site will be put into along with
  the static files from the _static_ directory.

* Created Configuration howto in README

= 1.6 / 2011.01.03

* Made rack to respond to paths like /about or /contact 
  by serving /about.html and /contact.html. 
  Rack still responds to / with index.html
* Migrated to BlueCloth in hope that one can then install 
  clay on Windows.

= pre 1.6

* Released a Gem.	
* Created Readme.	
* Text snippets
* Created rack/clay module for rack, so a created project 
  can be seved by rack.
