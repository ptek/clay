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
  
  def self.run_parallel command    
    pid = fork do 
      $stdout.reopen(File.open("/dev/null","w"))
      $stderr.reopen(File.open("/dev/null","w"))
      exec command
    end
    Process.detach pid
    sleep 1
    @spawned_processes ||= []
    @spawned_processes << pid
    pid
  end

  def self.stop pid
    Process.kill "SIGKILL", pid
  end

  def self.stop_all_parallel_processes
    @spawned_processes = @spawned_processes.map { |pid| self.stop pid; nil }.compact
  end
end
