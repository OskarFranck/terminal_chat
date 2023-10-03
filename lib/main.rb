#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'
require 'readline'
require 'io/console'
require_relative './logging.rb'
require_relative './prompt.rb'
require_relative './handle_args.rb'
require_relative './help.rb'
require_relative './context.rb'
require_relative './files.rb'

class Main
  include Logging
  include Files
  def self.run()
    config = load_env()

    ## This does not work. Need to fix this.
    if config == false
      Logging.log("No API key found.")
      Help.display_api_key()
      Logging.log('If you want to set your API key now, type (y)es and press enter.')
      while input = Readline.readline("> ", true) do
        if input.empty?
          Logging.log("Exiting.")
          exit
        elsif input == "y" || input == "yes" || input == "Y" || input == "Yes"
          set_key()
          exit
        else
          Logging.log('Invalid input (y)es or press enter to exit.')
        end
      end
    end

    context = Context.load_context()
    options_and_input = HandleArgs.handle_args()
    options = options_and_input.select { |k, v| k.start_with?("option_") }
    input = options_and_input["input"]

    halt_options = ["-h", "--help", "-v", "--version", "--key"]

    ## Hack... Need to fix this.
    if options.empty?
      options = { "option_0" => "simple" }
    end

    options.each do |k, v|
      if halt_options.include?(v)
        ## Options that halt the program.
        case v
        when "-h", "--help"
          Help.display_help()
          exit
        when "-v", "--version"
          Help.display_version()
          exit
        
        when "--key"
          set_key(api_key: nil)
        else
          Help.display_help()
          exit
        end
      else
        ## Options that don't halt the program.
        case v
        when "-f", "--file"
          file_as_string = Context.load_context_file()
          if file_as_string.empty?
            exit
          end
          Prompt.stream_prompt(input, file_as_string)
        when "-lf", "--loadfile"
          Logging.log("Loading File #{input}")
          Context.save_context_file(input)
        when "-d", "--delete"
          if input.nil?
            Context.delete_context()
          else
            Context.delete_context()
            Context.save_context(Prompt.stream_prompt(input, context))
          end
        when "-c", "--conversation"
          Logging.log(input)
          Context.save_context(Prompt.stream_prompt(input, context))
        when "-w", "--whisper"
          Logging.log(Prompt.whisper_transcribe(input))
        when "-t", "--translate"
          Logging.log(Prompt.whisper_translate(input))
        when "-i", "--interactive"
          Logging.log("Interactive mode...")
          Logging.log("Type 'exit' or 'quit' to exit.")
          Logging.log("Type 'clear' to clear context.")
          Logging.log("Type 'show' to show context.")
          Logging.log("Type 'help' to show help.")
          Logging.log("Type 'config' to change config.")
          Logging.log("Type '-w' to whisper transcribe.")
          Logging.log("Type '-t' to whisper translate.")

          while input = Readline.readline("\n> ", true) do
            case input
              when "exit", "quit"
                break
              when "clear"
                Logging.log("Clearing context...")
                Context.delete_context()
              when "help"
                #TODO: This should be a specific help for interactive. 
                Help.display_help()
              when "show"
                Logging.log("\n")
                Logging.log(Context.load_context())
              when /^-w/ 
                stript_input = input.sub(/^-w/, "").strip
                Logging.log(Prompt.whisper_transcribe(stript_input, interactive: true))
              when /^-t/
                stript_input = input.sub(/^-t/, "").strip
                Logging.log(Prompt.whisper_translate(stript_input, interactive: true))
              when "config"
                set_key(api_key: nil)
              else
                #options_and_input = HandleArgs.handle_args()
                context = Context.load_context()
                Logging.log("")
                Context.save_context(Prompt.stream_prompt(input, context))
                Logging.log("")
            end
          end
          Logging.log("Exiting...")
        when "simple"
          if !input.nil?
            Prompt.stream_prompt(input)
          else
            Logging.log("No input given.")
            Help.display_help()
          end
        else
          Help.display_help()
        end
      end
    end
  end

  private

  def self.set_key(api_key: nil)
    if api_key.nil?
      Logging.log("Setting API key...")
      Logging.log("Enter API key: (or press enter to exit)")

      while input = Readline.readline("> ", true) do
        if input.empty?
          Logging.log("Exiting.")
          exit
        else
          api_key = input.strip
          break
        end
      end
      Logging.log("Saving API key...")
    end

    FileUtils.mkdir_p(File.dirname(Files.config_path))
    File.open(Files.config_path, "w") do |f|
      f.write(YAML.dump({ "OPENAI_API_KEY" => api_key }))
    end
    Logging.log("API key saved.")
  end

  def self.load_env()
    YAML.load(File.read(Files.config_path))

  rescue Errno::ENOENT
    Logging.log("No config.yml found.")
  end
end

