require 'rubygems'


class Help
  extend Logging

  def self.display_version()
    ## Without using gemspec
    spec = Gem::Specification::find_by_name("ask-ai")
    log("Version: ask-ai-#{spec.version}")
  end

  def self.interactive_help(command)
    case command
    when '-w'
      log("Ex: -w /home/name/sound_file.m4a")
      log("Will transcribe the audio file.")
    when '-t'
      log("Ex: -t /home/name/sound_file.m4a")
      log("Will translate the audio file to English.")
    when '-lf'
      log("Ex: -lf /home/name/some_text_file.txt'")
      log("Will load the file into context.")
      log("The file should a [txt, CSV]. More formats coming soon.")
    when '-f'
      log("Ex: -f Can you describe the file i provided?")
    when 'config'
      log("Ex: config key <your API key>")
      log("Ex: config temp <0.0 - 1.0>")
      log("Ex: config context <0 - 100>")
      log("Beaware that the more context you use, the more expensive it will be.")
    else
      log("No help for: #{command}")
    end

  end

  def self.interactive_desc()
    log("Type 'exit' or 'quit' to exit.")
    log("Type 'models' to list available models.")
    log("Type 'clear' to clear context.")
    log("Type 'show' to show context.")
    log("Type 'debug <prompt>' to force print response, will show the whole response object.")
    log("Type 'help' to show help.\n  Try help <addional command> or <option> for detailed help\n  i.e help config or help -w")
    log("Type 'config [key, temp, context]' to change config.")
    log("Type '-w <filepath>' to whisper transcribe.")
    log("Type '-t' <filepath> to whisper translate.")
    log("Type '-lf' <filepath> to load file.")
    log "Type '-df' to delete file context."
    log("Type '-f' to use loaded file as context.")
  end
end
