require 'rubygems'
require 'bundler/setup'
require 'mustache'
require 'rdiscount'

module Goo
  
end

usage = %#
USAGE
$ goo <command>
  
COMMANDS
  init    - creates a directory structure for the project
  build   - builds the projects and creates the set of resulting static pages
  serve   - starts a local server
#
