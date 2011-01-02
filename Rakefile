require 'rubygems'
require 'rubygems/specification'
require 'bundler'

def gemspec_file
  'clay.gemspec'
end

def gemspec
  @gemspec ||= begin
    eval(File.read(gemspec_file), binding, gemspec_file)
  end
end

namespace :test do
  desc "Run all the tests"  
  task :all => [:unit, :acceptance]
  
  desc "Run the unit tests"
  task :unit do
    sh "rspec -c tests/unit"
  end
  
  desc "Run the acceptance tests"
  task :acceptance do
    sh "rspec -c tests/acceptance"
  end
end

desc "Build #{gemspec.name}-#{gemspec.version}.gem"
task :build do
  sh "gem build #{gemspec_file} && mv -f #{gemspec.name}-#{gemspec.version}.gem pkg"
end

desc "Install #{gemspec.name}-#{gemspec.version}.gem"
task :install => [:build] do
  sh "gem install pkg/#{gemspec.name}-#{gemspec.version}.gem"
end

desc "Uninstall #{gemspec.name}-#{gemspec.version} gem from the system gems"
task :uninstall do
  sh %{gem uninstall clay -x -v #{gemspec.version}}
end

desc "Publish #{gemspec.name}-#{gemspec.version}.gem"
task :publish => [:build] do
  sh "(sh pkg && gem push #{gemspec.name}-#{gemspec.version}.gem)"
end