module Files
  def given_project_files params
    dir = params[:in]
    FileUtils.rm_rf dir if File.exists?(dir)
    Shell::create_tmp_dir dir
    layouts = File.join(dir, "layouts/")
    unless params[:layouts].nil?
      FileUtils.mkdir_p(layouts) and FileUtils.cp(params[:layouts], layouts)
    end
    pages = File.join(dir, "pages/")
    unless params[:pages].nil?
      FileUtils.mkdir_p(pages) and FileUtils.cp(params[:pages], pages)
    end
  end

  def given_file content, path
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, "w"){|f| f.write content}
  end

  def files_should_be_equal file1, file2
    File.read(file1).should == File.read(file2)
  end

  def file_contents path
    File.read(path)
  end
end
