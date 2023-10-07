require 'rubygems'

class Help
  def self.display_help()
    Logging.log("Usage: aa [options] [input]")
    Logging.log("  -lf, --loadfile <path>: Load file into context")
    Logging.log("  -f, --file: Read from context file")
    Logging.log("  -c, --conversation: Append to conversation (max 10 Questions / Answers pairs saved)")
    Logging.log("  -d, --delete: Delete conversation")
    Logging.log("  -i, --interactive: Interactive mode, always a conversation. Clear context with 'clear' (exit with 'exit' or 'quit')")
    Logging.log("  -w, --whisper <path>: Transcribe audio file")
    Logging.log("  -t, --translate <path>: Translate audio file")
    Logging.log("\n  Options:")
    Logging.log("    --config: Edit config file")
    Logging.log("    -v, --version: Display version")
    Logging.log("    -h, --help: Display this help message")

  end
 
  def self.display_api_key()
    Logging.log("You need to set your API key in the file: ./config/config.yml")
    Logging.log("Create the file if it doesn't exist.")
    Logging.log("Add the following line to the file:")
    Logging.log("  OPENAI_API_KEY: <your API key>")
    Logging.log("You can get your API key from: https://openai.com/")
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
    spec = Gem::Specification::load("ask-ai.gemspec")
    Logging.log("Version: #{spec.version}")
  end

  def self.display_usage()
    Logging.log("Usage: ./main.rb [options] [input]")

    Logging.log("There are two types of options, flags and arguments.")
  end

  def self.interactive_help(command)
    case command
    when '-w'
      Logging.log("Ex: -w /home/name/sound_file.m4a")
      Logging.log("Will transcribe the audio file.")
    when '-t'
      Logging.log("Ex: -t /home/name/sound_file.m4a")
      Logging.log("Will translate the audio file to English.")
    when '-lf'
      Logging.log("Ex: -lf /home/name/some_text_file.txt'")
      Logging.log("Will load the file into context.")
      Logging.log("The file should a [txt, CSV]. More formats coming soon.")
    when '-f'
      Logging.log("Ex: -f Can you describe the file i provided?")
    when 'config'
      Logging.log("Ex: config key <your API key>")
      Logging.log("Ex: config temp <0.0 - 1.0>")
      Logging.log("Ex: config context <0 - 100>")
      Logging.log("Beaware that the more context you use, the more expensive it will be.")
    else
      Logging.log("No help for: #{command}")
    end

  end

  def self.interactive_desc()
    Logging.log("Type 'exit' or 'quit' to exit.")
    Logging.log("Type 'clear' to clear context.")
    Logging.log("Type 'show' to show context.")
    Logging.log("Type 'help' to show help.")
    Logging.log("Type 'config [key, temp, context]' to change config.")
    Logging.log("Type '-w <filepath>' to whisper transcribe.")
    Logging.log("Type '-t' <filepath> to whisper translate.")
    Logging.log("Type '-lf' <filepath> to load file.")
    Logging.log("Type '-f' to use loaded file as context.")
  end
end
