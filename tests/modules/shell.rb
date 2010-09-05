require 'ftools'

module Shell
  def change_to dir
    File.makedirs(dir) unless File.directory? dir 
    Dir.chdir dir
  end
  
  def directories_exist dirlist
    dirlist.each do |dir|
      unless File.directory?(dir)
        raise "Directory #{dir} do not exist."
      end
    end
  end
end