require 'rubygems'

class Help
  def self.display_help()
    puts "Usage: aa [options] [input]"
    puts "  -lf, --loadfile <path>: Load file into context"
    puts "  -f, --file: Read from context file"
    puts "  -c, --conversation: Append to conversation (max 10 Questions / Answers pairs saved)"
    puts "  -d, --delete: Delete conversation"
    puts "  -i, --interactive: Interactive mode, always a conversation. Clear context with 'clear' (exit with 'exit' or 'quit')"
    puts "  -w, --whisper <path>: Transcribe audio file"
    puts "  -t, --translate <path>: Translate audio file"
    puts "\n  Options:"
    puts "    --config: Edit config file"
    puts "    -v, --version: Display version"
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
    spec = Gem::Specification::load("aa.gemspec")
    puts "Version: #{spec.version}"
  end

  def self.display_usage()
    puts "Usage: ./main.rb [options] [input]"

    puts "There are two types of options, flags and arguments."
  end
end
