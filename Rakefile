require 'rubygems'
require 'rubygems/specification'
require 'bundler'
Bundler::GemHelper.install_tasks

def gemspec_file
  'goo.gemspec'
end

def gemspec
  @gemspec ||= begin
    eval(File.read(gemspec_file), binding, gemspec_file)
  end
end

desc "Uninstall #{gemspec.name}-#{gemspec.version} gem from the system gems"
task :uninstall do
  sh %{gem uninstall goo -x -v #{gemspec.version}}
end

namespace :test do
  desc "Run all the tests"  
  task :all => [:u, :a]
  
  desc "Run the unit tests"
  task :u do
    sh "bundle exec spec --color tests/unit"
  end
  
  desc "Run the acceptance tests"
  task :a do
    sh "bundle exec spec --color tests/acceptance"
  end
end

namespace :gems do
  desc "Update the dependencies for this application"
  task :u do
    sh "bundle update"
  end
  
  desc "Install the dependencies"
  task :i do
    sh "bundle install"
  end
end
