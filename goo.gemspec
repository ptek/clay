require "src/goo.rb"

Gem::Specification.new do |s|
  s.name = 'Goo'
  s.version = Goo.version
  s.summary = "A sticky glue to automatically form a static website."
  s.description = %{A sticky glue to automatically form a static website using Mustache templates and markdown files.}
  s.files = Dir['src/**/*.rb'] + Dir['tests/**/*.rb']
  s.require_path = 'src'
  s.autorequire = 'goo'
  s.has_rdoc = true
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.rdoc_options << '--title' <<  'Goo -- Site gluer'
  s.author = "Pavlo Kerestey"
  s.email = "pavlo@kerestey.net"
  s.homepage = "http://kerestey.net/goo"
end