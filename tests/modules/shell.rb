require 'fileutils'

module Shell
  
  def self.create_tmp_dir tmp_dir
    FileUtils.mkdir_p(tmp_dir) unless File.directory? tmp_dir
  end
  
  def self.directories_exist dirlist
    dirlist.each do |dir|
      unless File.exist?(dir)
        raise "Directory #{dir} do not exist.\nWorking dir is #{`pwd`}."
      end
    end
  end
  
  def self.files_exist filelist
    filelist.each do |file|
      unless File.exist?(file)
        raise "File #{file} do not exist.\nWorking dir is #{`pwd`}"
      end
    end
  end
end
