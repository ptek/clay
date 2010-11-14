require "src/clay"

describe "Clay" do
  it "should initialize a working directory using a project name" do
    expect_init "test_project"
    #when
    Clay.init "test_project"
  end
  
  it "should render the project" do
    expect_consistency_check
    expect_build_preparation
    expect_rendering_pages
    expect_publishing_public_directory
    #when
    Clay.form
  end
  
  it "should run a server on localhost:9393" do
    pending "find out how to test shell commands"
    expect_server_preparation
    expect_shell_command 'rackup -p 9393'
    #when
    Clay.serve
  end
  
  def given_project_files filelist
    @filelist = filelist
    @dirlist = filelist.map {|f| File.dirname(f)}
  end
  
  def expect_server_preparation
    Project.should_receive(:prepare_server_config).and_return(true)
  end
  
  def expect_init name
    Project.should_receive(:init).with(name).and_return(true)
  end
  
  def expect_consistency_check
    Project.should_receive(:check_consistency)
  end
  
  def expect_build_preparation
    Project.should_receive(:prepare_for_build).and_return(true)
  end
  
  def expect_rendering_pages
    Project.should_receive(:render_pages).and_return(true)
  end
  
  def expect_publishing_public_directory
    Project.should_receive(:publish_public_directory).and_return(true)
  end
end