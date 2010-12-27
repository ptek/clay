require 'src/clay'

require 'tests/modules/bdd.rb'

describe 'Text' do
  include Bdd
  it "should provide a hash of parsed contents of itself on init" do
    given_text "foo bar", 'texts/snippet_name.md'
    when_{Text.new("texts/snippet_name.md")}
    then_{|it|
      it.to_h.should == {"text-snippet_name"=>"<p>foo bar</p>"}
    }
  end

  def given_text contents, filename
    File.should_receive(:read).with(filename).and_return(contents)
  end
end
