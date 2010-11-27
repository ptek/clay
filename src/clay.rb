require 'rubygems'
require 'bundler/setup'
require 'mustache'
require 'rdiscount'
require 'fileutils'
require 'yaml'

module Clay
  VERSION = "0.4"
  
  def self.init project_name
    print "Creating the folder structure... "
    Project.init project_name
    puts "complete"
  end
  
  def self.form
    print "Forming... "
    Project.check_consistency
    Project.build
    puts "complete."
  end
  
  def self.run
    puts "Starting server on http://localhost:9292/"
    Project.prepare_rack_config
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
    init_clay_project? and layouts_exist? and pages_exist? and public_exist?
  end
    
  def self.build
    unless File.directory?("build")
      create_directory "build"
    end
    publish_public
    publish_pages
  end
    
  def self.prepare_rack_config
    unless File.exists? "config.ru"
      file = File.open("config.ru", "w")
      file.write "require 'rack/clay'\nrun Rack::Clay.new"
      file.close
    end
  end
  
  private
  
  def self.init_clay_project?
    `touch .clay` unless File.exists? ".clay"
  end
  
  def self.layouts_exist?
    create_directory "layouts"
  end
  
  def self.pages_exist?
    create_directory "pages"
  end

  def self.public_exist?
    create_directory "public"
  end
  
  def self.create_directory dirname
    return if dirname.nil? || dirname.empty?
    unless File.directory?(dirname)
      puts "#{dirname} must be a directory"
      FileUtils.rm_rf dirname
    end
    unless File.exists?(dirname)
      puts "Creating directory: #{dirname}"
      FileUtils.mkdir dirname
    end
  end

  def self.publish_pages
    Dir.glob("pages/*.*").each { |page|
      template = Template.parse(File.read(page))
      File.open(File.join("build/", File.basename(page)), "w") {|f| f.write template.render }
    }
  end

  def self.publish_public
    FileUtils.cp_r(Dir.glob("public/*"), "build")
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
