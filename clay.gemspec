# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)

require "src/clay"

Gem::Specification.new do |s|
  s.name        = "clay"
  s.version     = Clay::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pavlo Kerestey"]
  s.email       = ["pavlo@kerestey.net"]
  s.homepage    = "http://github.com/kerestey/clay"
  s.summary     = "A lightweight CMS for static websites"
  s.description = "A lightweight CMS to form a static website with layouts, files and text snippets."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "clay"

  s.add_dependency "mustache"
  s.add_dependency "bluecloth", ">= 2.0.9"
  s.add_dependency "rack"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"

  s.files        = `git ls-files`.split("\n").map{|f| f =~ /^src\/(.*)/ ? "src/"+$1 : nil}.compact
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = %w[src]
  
  #s.has_rdoc = true
  s.extra_rdoc_files	= %w[README.md]

  s.post_install_message = %Q{**************************************************

  Dear User, Thank you for installing #{s.name} - #{s.summary.downcase}.

  IMPORTANT CHANGES WITH THIS RELEASE (ver. 1.7): 
  directory public changed to be static Please rename Your project structure 
  to incorporate this change. This had to be done because of the way some 
  ruby webservers (like passenger for example) deal with the public directory.
  If You want to further use passenger or nginx to serve your site, You can
  leave the public directory intact. Just move its contents to the static
  directory, so the files will be copied over to the build directory when
  forming the site.

  Additionally You can now specify the build directory in config.yaml file
  by adding build_directory: "/path/to/the/build/dir". Your site will be 
  served out of this directory when You run $ clay run

  These Changes will allow to use passenger and putting the built site into
  the public directory so they are served by fast webservers like nginx or
  apache.

  The users who do not want to change anything, don't worry. All Your data
  will stay intact. You have to manually change your config.yaml to actually
  make the public directory be the build target location.

  Please be sure to look at the CHANGES to see what might have changed since 
  the last release:

  https://github.com/kerestey/clay/blob/master/CHANGES.md

  And happy New Year by the way :)

**************************************************
}
end
