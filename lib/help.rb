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
 
  def self.display_api_key()
    puts "You need to set your API key in the file: ./config/config.yml"
    puts "Create the file if it doesn't exist."
    puts "Add the following line to the file:"
    puts "  OPENAI_API_KEY: <your API key>"
    puts "You can get your API key from: https://openai.com/"
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
