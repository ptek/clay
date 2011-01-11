module Clay
  def clay
    @clay ||= File.expand_path('bin/clay')
  end
end
