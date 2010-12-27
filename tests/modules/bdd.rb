require 'fileutils'

module Bdd
  def given_workdir dirname
    @bdd_workdir = dirname
    FileUtils.mkdir dirname unless File.exists? dirname
  end

  def expect_error *message
    @bdd_expect_error = true
    *@bdd_expected_error_message = *message
  end

  def when_ &block
    if @bdd_expect_error
      lambda{
        @bdd_workdir.nil? ? block.call : Dir.chdir(@bdd_workdir) {block.call}
      }.should raise_error *@bdd_expected_error_message
    else
      @bdd_test_result = @bdd_workdir.nil? ? block.call : Dir.chdir(@bdd_workdir) {block.call}
    end
  end

  def then_ &block
    block.call @bdd_test_result
  end

  def stub name, expectations
    m = mock name
    expectations.to_a.each{|method,value| m.stub!(method).and_return(value)}
    m
  end
end
