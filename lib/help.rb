class Help
  def self.display_help()
    puts "Usage: ./main.rb [options] [input]"
    puts "  -f, --file: Read from file"
    ## Config?
    puts "  -c, --conversation: Append to conversation (max 10 Q / A saved)"
    puts "  -d, --delete: Delete conversation"
    puts "\n  Options:"
    puts "    -version, --version: Display version"
    puts "    -h, --help: Display this help message"

  end
  
  ## This don't work yet. Need to rework the way we handle args.
  def self.display_help_file()
    ## TODO: How to work with files
  end

  ## This don't work yet. Need to rework the way we handle args.
  def self.display_help_conversation()
    ## TODO: How to work with conversation
  end

  def self.display_version()
    puts "Version: 0.1.0"
  end

  def self.display_usage()
    puts "Usage: ./main.rb [options] [input]"

    puts "There are two types of options, flags and arguments."
  end
end
