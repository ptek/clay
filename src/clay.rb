require 'rubygems'
require 'mustache'
require 'bluecloth'
require 'fileutils'
require 'yaml'

module Clay
  VERSION = "1.7.5"

  def self.init project_name, silent=false
    mute(silent) {
      puts "Creating the folder structure... "
      project.init project_name
      puts "OK."
    }
  end

  def self.form silent=false
    mute(silent){
      puts "Forming... "
      project.check_consistency
      project.build
      puts "OK."
    }
  end

  def self.run silent=false
    mute(silent) {
      puts "Starting server on http://localhost:9292/"
      project.prepare_rack_config
      exec "rackup config.ru"
    }
  end

  private

  def self.mute silent
    stdout = STDOUT.dup
    $stdout.reopen(File.open("/dev/null", "w")) if silent
    yield
    $stdout.reopen(stdout)
  end

  def self.project
    Project.new project_root
  end

  def self.project_root
    `pwd`.strip
  end

end

class Hash
  def deep_copy
    Marshal.load(Marshal.dump(self))
  end
end

class Project
  def initialize project_root
    @project_root = project_root
  end

  def init name
    create_directory name
    Dir.chdir name do
      @project_root = File.join(@project_root, name)
      check_consistency
    end
  end

  def check_consistency
    init_clay_project? and layouts_exist? and pages_exist? and static_exist? and texts_exist?
  end

  def build
    target = configs["target_dir"] ? configs["target_dir"] : "build"
    unless File.directory?(path(target))
      create_directory path(target)
    end
    publish_static target
    texts = interpret_texts
    publish_pages target, texts
  end

  def prepare_rack_config
    unless File.exists? path("config.ru")
      file = File.open(path("config.ru"), "w")
      file.write "require 'rack/clay'\nrun Rack::Clay.new"
      file.close
    end
  end

  def configs
    result = YAML.load(File.read(path("config.yaml")))
    conf_options = result.keys - ["autoreload", "target_dir"]
    raise "ERROR in config.yaml" if conf_options.length > 0
    result
  rescue Errno::ENOENT
    {}
  end

private

  def init_clay_project?
    `touch '#{path(".clay")}'` unless File.exists? path(".clay")
  end

  def layouts_exist?
    create_directory path("layouts")
  end

  def pages_exist?
    create_directory path("pages")
  end

  def static_exist?
    create_directory path("static")
  end

  def texts_exist?
    create_directory path("texts")
  end

  def create_directory dirname
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

  def publish_static target
    FileUtils.cp_r(Dir.glob("static/*"), target)
  end

  def interpret_texts
    data = {}
    texts = Dir.glob("texts/*") # =>
    texts.each do |filename|
      begin
        data.merge! Text.new(filename).to_h
      rescue RuntimeError => e
        puts "Warning: ", e.message
      end
    end
    data
  end

  def publish_pages target, initial_data=nil
    Dir.glob("pages/*.*").each { |page_path|
      begin
        data = initial_data.deep_copy
        page = Page.new(page_path, target, data)
        File.open(page.target, "w") {|f| f.write page.content }
      rescue RuntimeError => e
        puts "Warning: ", e.message
      end
    }
  end

  def path filename
    File.expand_path(File.join("#{@project_root}/", filename))
  end

end

class Page
  attr_reader :content
  def initialize filename, target=nil, data=nil
    case filename.split(".").last
    when "md", "markdown" then @page_type = "markdown"
    when "html" then @page_type = "html"
    else raise "File type of #{filename} unknown. Shouldn\'t it be in the static directory?"
    end
    @target = target.nil? ? "build" : target
    @filename = filename_within_pages filename
    file_content = File.read(filename)
    data ||= {}
    layout, raw_content, new_data = interpret file_content
    data.merge! new_data
    @content = render raw_content, layout, @page_type, data
  end

  def target
    file_base = @filename.split(".")[0..-2].join('.')
    "#{@target}/#{file_base}.html"
  end

private
  def filename_within_pages filename
    filename.split("/", 2)[1]
  end

  def render content, layout, page_type, data
    data['content'] = parsed_content content, data
    begin
      layout_content = File.read(layout)
    rescue NameError
      raise "Layout #{layout} is missing.\nPlease create one in layouts directory"
    end
    rendered_content = Mustache.render(layout_content, data)
  end

  def parsed_content content, data
    case @page_type
    when "markdown" then return Mustache.render(BlueCloth.new(content).to_html.strip, data)
    when "html" then return Mustache.render(content, data)
    end
  end

  def interpret content
    layout_name = "default"
    data = {}
    if content.match(/^(\s*---(.+)---\s*)/m)
      data = YAML.load($2.strip)
      content = content.gsub($1, "")
      layout_name = data.delete "layout" if data["layout"]
    end
    layout = "layouts/#{layout_name}.html"
    return layout, content, data
  end
end

class Text
  attr_reader :content
  def initialize filename
    extension = File.extname(filename)
    @name = File.basename(filename, extension)
    raise "Text must be a markdown file" unless extension == ".md" or extension == ".markdown"
    @content = parse File.read(filename)
  end

  def to_h
    {"text-#{@name}" => content}
  end

private

  def parse content
    BlueCloth.new(content).to_html.strip
  end
end
