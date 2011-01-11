require "tests/modules/bdd"
require "tests/modules/files"
require "tests/modules/clay"
require "tests/modules/shell"

describe "Clay local server" do
  include Bdd
  include Files
  include Clay

  before :all do
    clay_binary = clay
  end

  it "runs and delivers a page on localhost:9292" do
    given_file "", "tests/tmp/test_project/.clay"
    given_file "autoreload: false", "tests/tmp/test_project/config.yaml"
    given_file "<layout>{{{content}}}</layout>", "tests/tmp/test_project/layouts/default.html"
    given_file "<p>Foo Bar</p>", "tests/tmp/test_project/pages/index.html"
    given_workdir "tests/tmp/test_project"
    when_{`#{clay} form`; Shell.run_parallel("#{clay} run")}
    then_{
      `curl -s localhost:9292`.should == "<layout><p>Foo Bar</p></layout>"
    }
  end

  it "runs and updates a page if files change and autoreload is set to true in config" do
    given_file "", "tests/tmp/test_project/.clay"
    given_file "<layout>{{{content}}}</layout>", "tests/tmp/test_project/layouts/default.html"
    given_file "<p>Foo Bar</p>", "tests/tmp/test_project/pages/index.html"
    given_file "autoreload: true", "tests/tmp/test_project/config.yaml"
    given_workdir "tests/tmp/test_project"    
    local_server_pid = running_local_server
    when_{ writing "<p>Baz</p>", "pages/index.html" }
    then_{ 
      `curl -s localhost:9292`.should == "<layout><p>Baz</p></layout>"
    }
  end

  it "serves the site from a directory specified by target_dir in config.yaml" do
    given_file "", "tests/tmp/test_project/.clay"
    given_file "<layout>{{{content}}}</layout>", "tests/tmp/test_project/layouts/default.html"
    given_file "<p>Foo Bar</p>", "tests/tmp/test_project/pages/index.html"
    given_file "autoreload: true\ntarget_dir: public", "tests/tmp/test_project/config.yaml"
    given_workdir "tests/tmp/test_project"    
    when_{ Shell.run_parallel("#{clay} run") }
    then_{
      `curl -s localhost:9292`.should == "<layout><p>Foo Bar</p></layout>"
      `ls tests/tmp/test_project`.split("\n").include?("public").should == true
      `ls tests/tmp/test_project`.split("\n").include?("build").should == false
    }
  end

  after :each do
    `rm -rf tests/tmp`
    Shell.stop_all_parallel_processes
  end

  def running_local_server
    when_{Shell.run_parallel("#{clay} run")}
  end

  def writing content, file_path
    File.open(file_path, "w"){|f| f.write content}
  end
end
