require 'tests/modules/shell'
include Shell

describe "cli" do
  before :all do
    `rake build && rake deploy`
  end
  
  it "should create the initial project structure" do
    #given
    change_to "/tmp/goo"
    
    #when
    res = `goo init project`
    
    #then
    res.should == "OK"
    directories_exist [
      "/tmp/goo/project",
      "/tmp/goo/project/pages",
      "/tmp/goo/project/layout",
      "/tmp/goo/project/posts"
    ]
  end
end