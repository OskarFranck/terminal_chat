module Files
  def root
    File.expand_path("./../", __dir__)
  end

  def file_path
    File.expand_path("./../files/", __dir__)
  end

  def context_path
    File.expand_path("./../files/context.jsonl", __dir__)
  end

  def config_path
    File.expand_path("./../config/config.yml", __dir__)
  end

  def context_file_path
    File.expand_path("./../files/context_file.txt", __dir__)
  end
end
