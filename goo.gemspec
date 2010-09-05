# -*- encoding: utf-8 -*-
require "lib/goo"

Gem::Specification.new do |s|
  s.name        = "goo"
  s.version     = Goo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pavlo Kerestey"]
  s.email       = ["pavlo@kerestey.net"]
  s.homepage    = "http://kerestey.net/goo"
  s.summary     = "A sticky glue to automatically form a static website."
  s.description = "A sticky glue to automatically form a static website using Mustache templates and markdown files."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "goo"

  s.add_development_dependency "bundler", ">= 1.0.0.rc.6"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
