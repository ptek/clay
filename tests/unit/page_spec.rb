require 'tests/modules/bdd'
require 'src/clay.rb'

describe "Page" do
  include Bdd

  it "should interpret plain html text with default layout" do
    given_page "<p>Foo Bar</p>", "pages/test.html"
    given_layout "<div>{{{content}}}</div>", "layouts/default.html"
    when_{Page.new("pages/test.html")}
    then_{|it|
      it.target.should == "build/test.html"
      it.content.should == "<div><p>Foo Bar</p></div>"
    }
  end

  it "should interpret plain html text including data with default layout" do
    given_page """
---
layout: with_title
title: foo
---
<p>bar</p>
""", "pages/foo.html"
    given_layout "<t>{{title}}</t><div>{{{content}}}</div>", "layouts/with_title.html"
    when_{Page.new("pages/foo.html")}
    then_{|it|
      it.target.should == "build/foo.html"
      it.content.should == "<t>foo</t><div><p>bar</p>\n</div>"
    }
  end

  it "should interpret markdown text including data with default layout" do
    given_page """
---
bar: baz
---

Foo
===

{{bar}}
""", "pages/index.md"
    given_layout "<div>{{{content}}}</div>", "layouts/default.html"
    when_{Page.new("pages/index.md")}
    then_{|it|
      it.target.should == "build/index.html"
      it.content.should == "<div><h1>Foo</h1>\n\n<p>baz</p></div>"
    }
  end

  it "should interpret a page and render it with text snippets provided in the data" do
    given_layout "<div>{{{content}}}</div>", "layouts/default.html"
    given_page "<span>{{{text-foo}}}</span>", "pages/index.html"
    when_{Page.new("pages/index.html", {"text-foo" => "<p>bar</p>"})}
    then_{|it|
      it.content.should == "<div><span><p>bar</p></span></div>"
    }
  end

  it "should raise an error if the file type can not be identified properly" do
    expect_error "File type of pages/index.txt unknown. Shouldn\'t it be in the static directory?"
    when_{Page.new "pages/index.txt"}
  end

  it "should raise an error if layout file can not be found" do
    given_page "---\nlayout: missing\n---\nFoo Bar", "pages/baz.md"
    given_layout_does_not_exist "layouts/missing.html"
    expect_error "Layout layouts/missing.html is missing.\nPlease create one in layouts directory"
    when_{Page.new("pages/baz.md")}
  end

private
  def given_layout content, filename
    File.should_receive(:read).with(filename).once.and_return(content)
  end

  def given_layout_does_not_exist filename
    File.should_receive(:read).with(filename).once.and_raise(NameError)
  end

  def given_page content, filename
    File.should_receive(:read).with(filename).once.and_return(content)
  end
end
