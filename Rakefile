task :build do
  puts "Building"
end

task :deploy => [:build] do
  puts "Deploying"
end

namespace :test do
  desc "Run all the tests"  
  task :all => [:u, :a]
  
  desc "Run the unit tests"
  task :u do
    sh "bundle exec spec --color tests/unit"
  end
  
  desc "Run the acceptance tests"
  task :a => [:deploy] do
    sh "bundle exec spec --color tests/acceptance"
  end
end

namespace :gems do
  desc "Update the gems for this application"
  task :u do
    sh "bundle update"
  end
  
  desc "Installs the gems specified in the Gemfile"
  task :i do
    sh "bundle install"
  end
end
