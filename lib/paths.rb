
module Files
  def self.root
    File.expand_path("./../", __dir__)
  end

  def self.context
    File.expand_path("./../files/context.jsonl", __dir__)
  end

  def self.files
    FILE_PATH
  end

  def self.config
    CONFIG_PATH
  end

  def self.context_file
    CONTEXT_FILE_PATH
  end
end
CONTEXT_PATH = File.expand_path("./../files/context.jsonl", __dir__)
FILE_PATH = File.expand_path("./../files/", __dir__)
CONFIG_PATH = File.expand_path("./../config/config.yml", __dir__)
CONTEXT_FILE_PATH = File.expand_path("./../files/context_file.txt", __dir__)
