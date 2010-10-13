require 'fileutils'
require 'rubygems'
require 'tests/modules/shell'

describe "cli" do
  before :all do
    clay_binary = clay
  end
  
  it "should create the initial project structure" do
    given_working_dir "tests/tmp" do
      #when
      `#{clay} init project_name`
    end
    #then
    Shell::directories_exist [
      "tests/tmp/project_name/.clay",
      "tests/tmp/project_name/pages",
      "tests/tmp/project_name/layouts"
    ]
  end
  
  it "should convert a single layout file into index page." do
    given_project_files(:layouts => "tests/data/layouts/default.html", :pages => "tests/data/pages/index.html", :in => "tests/tmp/clay/")
    given_working_dir "tests/tmp/clay" do
    #when
      `#{clay} form`
    end
    #then
    File.directory? "tests/tmp/clay/build"
    files_should_be_equal "tests/tmp/clay/build/index.html", "tests/data/build/index.html"
  end
  
  after :each do
    FileUtils.rm_rf "tests/tmp"
  end
  
  private

  def clay
    @clay ||= File.expand_path('bin/clay')
  end
  
  def given_working_dir dir
    Shell::create_tmp_dir(dir) unless File.directory?(dir)
    Dir.chdir(dir) {yield}
  end
  
  def given_project_files params
    dir = params[:in]
    Shell::create_tmp_dir dir unless File.directory?(dir)
    layouts = File.join(dir, "layouts/")
    unless params[:layouts].nil?
      FileUtils.mkdir_p(layouts) and FileUtils.cp(params[:layouts], layouts)
    end
    pages = File.join(dir, "pages/")
    unless params[:pages].nil?
      FileUtils.mkdir_p(pages) and FileUtils.cp(params[:pages], pages)
    end
  end

  def files_should_be_equal file1, file2
    File.read(file1).should == File.read(file2)
  end

end