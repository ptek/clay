require 'rubygems'
require 'bundler/setup'
require 'mustache'
require 'rdiscount'
require 'fileutils'
require 'yaml'

require File.join(File.dirname(__FILE__), 'diff')

module Clay
  VERSION = "0.4"
  
  def self.init project_name
    print "creating the structure ..."
    Project.init project_name
    puts " complete"
  end
  
  def self.form
    print "Forming site ..."
    Project.check_consistency
    Project.prepare_for_build
    Project.render_pages
    Project.publish_public_directory
    puts " complete."
  end
  
  def self.run
    puts "starting server on http://localhost:9292/"
    Project.prepare_server_config
    `rackup config.ru`
  end
end

class Project
  def self.init name
    create_directory name
    Dir.chdir name do
      check_consistency
    end
  end
  
  def self.check_consistency
    is_clay_project? and layouts_exist? and pages_exist?
  end
  
  def self.prepare_for_build
    unless File.directory?("build")
      create_directory "build"
    end
  end
  
  def self.render_pages
    Dir.glob("pages/*.*").each { |page|
      template = Template.parse(File.read(page))
      File.open(File.join("build/", File.basename(page)), "w") {|f| f.write template.render }
    }
  end
  
  def self.publish_public_directory
    FileUtils.cp_r(Dir.glob("public/*"), "build")
  end
  
  def self.prepare_server_config
    unless File.exists? "config.ru"
      file = File.open("config.ru", "w")
      file.write "require 'rack/clay'\nrun Rack::Clay.new"
      file.close
    end
  end
  
  private
  
  def self.is_clay_project?
    `touch .clay` unless File.exists? ".clay"
  end
  
  def self.layouts_exist?
    unless File.directory?("layouts")
      puts "Layouts directory does not exist. Trying to create it."
      create_directory "layouts"
    end
  end
  
  def self.pages_exist?
    unless File.directory?("pages")
      puts "Pages directory does not exist. Trying to create it."
      create_directory "pages"
    end
  end
  
  def self.create_directory name
    FileUtils.mkdir name
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
