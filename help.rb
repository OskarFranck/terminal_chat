class Help
  def self.display_help()
    puts "Usage: ./main.rb [options] [input]"
    puts "Options:"
    puts "  -f, --file: Read from file"
    puts "  -version, --version: Display version"
    puts "  -h, --help: Display this help message"
  end

  def self.display_version()
    puts "Version: 0.1.0"
  end

  def self.display_usage()
    puts "Usage: ./main.rb [options] [input]"

    puts "There are two types of options, flags and arguments."
  end
end
