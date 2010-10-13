require 'rubygems'
require 'rubygems/specification'
require 'bundler'
Bundler::GemHelper.install_tasks

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
    sh "bundle exec rspec --color tests/unit"
  end
  
  desc "Run the acceptance tests"
  task :acceptance do
    sh "bundle exec rspec --color tests/acceptance"
  end
end

namespace :gems do
  desc "Update the dependencies for this application"
  task :update do
    sh "bundle update"
  end
  
  desc "Install the dependencies"
  task :install do
    sh "bundle install"
  end
end

task :build do
  #handled by bundler mixins
  #sh "gem build #{gemspec_file} && mv -f #{gemspec.name}-#{gemspec.version}.gem pkg"
end

task :install do
  #handled by bundler mixins
  #sh "gem install pkg/#{gemspec.name}-#{gemspec.version}.gem"
end

desc "Uninstall #{gemspec.name}-#{gemspec.version} gem from the system gems"
task :uninstall do
  sh %{gem uninstall clay -x -v #{gemspec.version}}
end