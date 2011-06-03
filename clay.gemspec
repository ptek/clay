# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)

require "src/clay"

Gem::Specification.new do |s|
  s.name        = "clay"
  s.version     = Clay::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pavlo Kerestey"]
  s.email       = ["pavlo@kerestey.net"]
  s.homepage    = "http://kerestey.github.com/clay"
  s.summary     = "A lightweight CMS for static websites"
  s.description = "A lightweight CMS to form a static website with layouts, files and text snippets."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "clay"

  s.add_dependency "mustache"
  s.add_dependency "kramdown", ">= 0.13.3"
  s.add_dependency "rack"
  s.add_dependency "json"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"

  s.files        = `git ls-files`.split("\n").map{|f| f =~ /^src\/(.*)/ ? "src/"+$1 : nil}.compact
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = %w[src]
  
  #s.has_rdoc = true
  s.extra_rdoc_files	= %w[README.md]
end
