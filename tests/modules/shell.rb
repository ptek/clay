require 'ftools'
require 'tmpdir'

module Shell
  
  def self.create_tmp_dir
    File.makedirs(tmp_dir) unless File.directory? tmp_dir
  end
  
  def self.directories_exist dirlist
    dirlist.each do |dir|
      unless File.directory?(dir)
        raise "Directory #{dir} do not exist."
      end
    end
  end
  
  def self.files_exist filelist
    filelist.each do |file|
      unless File.exist?(dir)
        raise "Directory #{dir} do not exist."
      end
    end
  end
  
  def self.tmp_dir 
    Dir.tmpdir()+"/goo"
  end
  
  def self.clean_up_tmp_dir
    `rm -rf #{tmp_dir}`
  end
end