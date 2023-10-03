module Files
  def self.root
    File.expand_path("./../", __dir__)
  end

  def self.file_path
    File.expand_path("./../files/", __dir__)
  end

  def self.context_path
    File.expand_path("./../files/context.jsonl", __dir__)
  end

  def self.config_path
    File.expand_path("./../config/config.yml", __dir__)
  end

  def self.context_file_path
    File.expand_path("./../files/context_file.txt", __dir__)
  end
end
