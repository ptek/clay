require 'rubygems'
require 'bundler/setup'
require 'mustache'
require 'rdiscount'
require 'fileutils'

module Clay
  VERSION = "0.2"
  
  def self.init project_name
    print "creating the structure ..."
    FileUtils.mkdir_p [ "#{project_name}/.clay", "#{project_name}/pages", "#{project_name}/layouts" ]
    puts " complete"
  end
  
  def self.form
    print "Forming site ..."
    unless File.directory?("layouts")
      raise "Layouts are missing. Please create at least one layout in the 'layouts' directory" 
    end
    unless File.directory?("pages")
      raise "Pages are missing. Please create at least one page in the 'pages' directory" 
    end
    FileUtils.mkdir_p("build")
    Dir.glob("pages/*.*").each { |page|
      template = Template.parse(File.read(page))
      File.open(File.join("build/", File.basename(page)), "w") {|f| f.write template.render }
    }
    FileUtils.cp_r(Dir.glob("public/*"), "build") unless Dir["public"].empty?
    puts " complete."
  end
  
  def self.serve
    puts "starting server on port 9393. Press ^C to terminate."
    File.open("config.ru", "w"){|f| f.write "require 'rack/clay'\nrun Rack::Clay.new"} unless File.exists? "config.ru"
    `rackup -p 9393`
  end
end

class Layout
  def initialize layout_content, insert_content, data = {}
    @insert_content = insert_content
    @layout_content = layout_content
    @data = data
  end
  
  def render
    @data["yield"] = @insert_content
    Mustache.render(@layout_content, @data)
  end

  def self.parse name, content, data = {}
    return DefaultLayout.new content, data if name == "default"
    
    insert_content = content
    layout_content = File.read "layouts/#{name.downcase}.html"
    
    if layout_content.match(/^(\s*---(.+)---\s*)/m)
      data.merge! YAML.load($2.strip)
      layout_content = content.gsub($1, "")
      parent_layout_name = data.delete "layout" if data["layout"]
      parent_layout = Layout.parse parent_layout_name, layout_content, data
      layout_content = parent_layout.render
    end
    
    self.new layout_content, insert_content, data
  end
end

class DefaultLayout < Layout
  def initialize content, data = {}
    @data = data
    @insert_content = content
    @layout_content = File.read "layouts/default.html"
    @layout_content = parse
  end
  
private
  
  def parse
    if @layout_content.match(/^(\s*---(.+)---\s*)/m)
      @data = @data.merge! YAML.load($2.strip)
      @layout_content = @layout_content.gsub($1, "")
    else
      @layout_content
    end
  end
end

class Template
  def initialize content, layout_name = nil, data = {}
    layout_name ||= "default"
    @layout = Layout.parse layout_name, content, data
    File.open("/tmp/debug", "a"){|f| f.write "#{Time.new} #{@layout.inspect}\n"}
    @content = @layout.render
    @data = data
  end
  
  def self.parse content
    if content.match(/^(\s*---(.+)---\s*)/m)
      data = YAML.load($2.strip)
      content = content.gsub($1, "")
      layout_name = data.delete "layout" if data["layout"]
      self.new content, layout_name, data
    else
      self.new content
    end
  end
  
  def render
    Mustache.render(@content, @data)
  end
end