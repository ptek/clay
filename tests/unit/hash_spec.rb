require 'src/clay'

describe "Hash" do
  it "can be copied completely" do
    {}.deep_copy.should == {}
    {"a"=>"b"}.deep_copy.should == {"a"=>"b"}
    {"a"=>{"b"=>"c"}}.deep_copy.should == {"a"=>{"b"=>"c"}}
  end

  it "can be coped and the operaions on the copy do not affect the original" do
    a = {"foo"=>"bar"}
    b = a.deep_copy
    b.should == a
    b["foo"] = "baz"
    a["foo"].should == "bar"
    b["foo"].should == "baz"
  end
end
