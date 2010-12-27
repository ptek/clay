require 'fileutils'
require 'rubygems'
require 'tests/modules/shell'
require 'tests/modules/bdd'

describe "cli" do
  include Bdd

  before :all do
    clay_binary = clay
  end
  
  it "should create the initial project structure" do
    given_workdir "tests/tmp"
    when_{`#{clay} init very_special_project_name`}
    then_{ |result|
      Shell::directories_exist [
                                "tests/tmp/very_special_project_name/.clay",
                                "tests/tmp/very_special_project_name/pages",
                                "tests/tmp/very_special_project_name/layouts"
                               ]
    }
  end
  
  it "should convert a single page html file into a html page with layout." do
    given_project_files(:layouts => "tests/data/layouts/default.html", 
                        :pages => "tests/data/pages/index.html", 
                        :in => "tests/tmp/test_project/")
    given_workdir "tests/tmp/test_project"
    when_{ `#{clay} form` }
    then_{ |result|
      File.directory? "tests/tmp/test_project/build"
      files_should_be_equal "tests/tmp/test_project/build/index.html", "tests/data/build/index.html"
    }
  end

  it "should convert a single page markdown file into a html page with layout." do
    given_project_files(:layouts => "tests/data/layouts/default.html", 
                        :pages => "tests/data/pages/markdown_page.md", 
                        :in => "tests/tmp/test_project/")
    given_workdir "tests/tmp/test_project"
    when_{ `#{clay} form` }
    then_{ |result|
      files_should_be_equal("tests/tmp/test_project/build/markdown_page.html", 
                            "tests/data/build/markdown_page.html")
    }
  end
  
  after :each do
    FileUtils.rm_rf "tests/tmp"
  end
  
  private

  def clay
    @clay ||= File.expand_path('bin/clay')
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
