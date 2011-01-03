require "tests/modules/bdd"
require "src/clay"

describe "Clay" do
  include Bdd
  
  it "should initialize a working directory using a project name" do
    given_project `pwd`.strip
    expect_init "test_project"
    when_{Clay.init "test_project"}
  end
  
  it "should render the project" do
    given_project `pwd`.strip
    expect_consistency_check
    expect_build
    when_{Clay.form}
  end
  
  it "should run a server on localhost:9393" do
    pending "find out how to test shell commands"
    expect_server_preparation
    expect_shell_command 'rackup -p 9292'
    when_{Clay.serve}
  end
  
  def expect_init name
    @project_mock.should_receive(:init).with(name).and_return(true)
  end
  
  def expect_consistency_check
    @project_mock.should_receive(:check_consistency)
  end
  
  def expect_build
    @project_mock.should_receive(:build).and_return(true)
  end
  
  def given_project root_path
    @project_mock = mock :project
    Project.should_receive(:new).with(root_path).at_least(1).times.and_return(@project_mock)
  end
end
