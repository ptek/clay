require "rack"
require "rack/request"
require "rack/response"
require "fileutils"
require "yaml"

module Rack
  class Clay
    def initialize(opts = {})
      @configfile = ::File.join(::Dir.pwd,"config.yaml")
      @config = {}
      if ::File.exist?(@configfile)
        puts "Reading configs... "
        @config = ::YAML.load(::File.read(@configfile))
        @config = (@config.class == FalseClass ? {} : @config)
        if @config[:destination].nil?
          @path = opts[:destination].nil? ? "build" : opts[:destination]
        else
          opts.merge!(@config)
          @path = @config[:destination].nil? ? "build" : @config[:destination]
        end
        puts @config.inspect
        puts "Ready."
      end

      @path = "build"
      @path = @config["build_path"] if @config["build_path"]
      @mimes = Rack::Mime::MIME_TYPES.map{|k,v| /#{k.gsub('.','\.')}$/i }
    end
    def call(env)
      rebuild

      request = Request.new(env)
      path_info = request.path_info
      @files = ::Dir[@path + "/**/*"].inspect      
      path_info += ".html" if @files.include?(path_info+".html")
      if @files.include?(path_info)
        if path_info =~ /(\/?)$/
          if @mimes.collect {|regex| path_info =~ regex }.compact.empty?
            path_info += $1.nil? ? "/index.html" : "index.html"
          end
        end
        mime_type = mime(path_info)

        file = file_info(@path + path_info)
        body = file[:body]
        time = file[:time]

        if time == request.env['HTTP_IF_MODIFIED_SINCE']
          [304, {'Last-Modified' => time}, []]
        else
          [200, {"Content-Type" => mime_type, "Content-length" => body.length.to_s, 'Last-Modified' => time}, [body]]
        end
      else
        status, body, path_info = ::File.exist?(@path+"/404.html") ? [404,file_info(@path+"/404.html")[:body],"404.html"] : [404,"Not found","404.html"]
        mime_type = mime(path_info)
        [status, {"Content-Type" => mime_type, "Content-length" => body.length.to_s}, [body]]
      end
    end

    def file_info(path)
      expand_path = ::File.expand_path(path)
      ::File.open(expand_path, 'r') do |f|
        {:body => f.read, :time => f.mtime.httpdate, :expand_path => expand_path}
      end
    end

    def mime(path_info)
      if path_info !~ /html$/i
        ext = $1 if path_info =~ /(\.\S+)$/
        Mime.mime_type((ext.nil? ? ".html" : ext))
      else
        Mime.mime_type(".html")
      end
    end
    
    def rebuild
      if @config["autoreload"]
        require 'json'
        clayfile = ::File.join(::Dir.pwd, ".clay")
        old_file_hashes = ::File.read(clayfile)
        new_file_hashes = get_file_hashes
        changes = compare_file_hashes old_file_hashes, new_file_hashes.to_json
        unless changes
          begin                                   
            require 'clay'                        
            ::Clay.form                           
          rescue LoadError                        
            raise "Could not load clay"
          end
        end
        ::File.open(clayfile, "w") {|f| f.write(new_file_hashes.to_json)}
      end
    end

    def get_file_hashes
      files = ::Dir.glob("**/*") - [@path] - ::Dir.glob(@path + "/**/*")
      file_hashes_array = files.map {|filename| [filename, file_hash(filename)]}
      file_hashes = Hash[*file_hashes_array.flatten]
    end
    
    def file_hash filename
      ::File.new(filename).mtime.to_s
    end

    def compare_file_hashes old, new
      old == new
    end
  end
end
