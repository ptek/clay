require 'rubygems'
require 'tests/modules/shell'

describe "cli" do
  before :all do
    Shell::create_tmp_dir
    goo
  end
  
  it "should create the initial project structure" do
    Dir.chdir(tmp_dir) do
      
      `#{goo} init proj`
      
      Shell::directories_exist [
        "#{tmp_dir}/proj/pages",
        "#{tmp_dir}/proj/layout",
        "#{tmp_dir}/proj/posts"
      ]
    end
  end
  
  it "should convert a single layout file into index page." do
    
  end
  
  after :all do
    Shell::clean_up_tmp_dir
  end
  
  private
  
  def tmp_dir
    @tmp_dir ||= Shell::tmp_dir
  end
  
  def goo
    @goo ||= File.expand_path('bin/goo')
  end
end