# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)

require "src/clay"

Gem::Specification.new do |s|
  s.name        = "clay"
  s.version     = Clay::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pavlo Kerestey"]
  s.email       = ["pavlo@kerestey.net"]
  s.homepage    = "http://kerestey.net/clay"
  s.summary     = "A sticky clay to automatically form a static website."
  s.description = "A sticky clay to automatically form a static website using Mustache templates and markdown files."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "clay"

  s.add_dependency "mustache", "~> 0.11"
  s.add_dependency "rdiscount"
  s.add_dependency "rack"
  s.add_dependency "shotgun"

  s.add_development_dependency "bundler", "~> 1.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"

  s.files        = `git ls-files`.split("\n").map{|f| f =~ /^src\/(.*)/ ? "src/"+$1 : nil}.compact
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = %w[src]
  
  s.has_rdoc = false
  #s.extra_rdoc_files	= %w[README.markdown]
end