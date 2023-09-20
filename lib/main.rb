#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'
require 'readline'
require 'bcrypt'
require 'io/console'
[
  './prompt.rb',
  './handle_args.rb',
  './help.rb',
  './context.rb'
].each { |f| require_relative f }

CONTEXT_PATH = File.expand_path("./../files/context.jsonl", __dir__)
FILE_PATH = File.expand_path("./../files/", __dir__)
CONFIG_PATH = File.expand_path("./../config/config.yml", __dir__)
CONTEXT_FILE_PATH = File.expand_path("./../files/context_file.txt", __dir__)
class Main

  def self.run()
    config = load_env()
 
    ## This does not work. Need to fix this.
    if config.nil? || config['OPENAI_API_KEY'].nil?
      puts "No API key found."
      Help.display_api_key()
      puts 'If you want to set your API key now, type (y)es and press enter.'
      #puts "If you have an API key you can set it here."
      #puts "Enter API key: (or press enter to exit)"

      while input = Readline.readline("> ", true) do
        if input.empty?
          puts "Exiting."
          exit
        elsif input == "y" || input == "yes" || input == "Y" || input == "Yes"
          set_key()
          exit
        else
          puts 'Invalid input (y)es or press enter to exit.'
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
          puts "Loading File #{input}"
          Context.save_context_file(input)
        when "-d", "--delete"
          if input.nil?
            Context.delete_context()
          else
            Context.delete_context()
            Context.save_context(Prompt.stream_prompt(input, context))
          end
        when "-c", "--conversation"
          puts input
          Context.save_context(Prompt.stream_prompt(input, context))
        when "-w", "--whisper"
          puts Prompt.whisper_transcribe(input)
        when "-t", "--translate"
          puts Prompt.whisper_translate(input)
        when "-i", "--interactive"
          puts "Interactive mode..."
          puts "Type 'exit' or 'quit' to exit."
          puts "Type 'clear' to clear context."

          while input = Readline.readline("\n> ", true) do
            if (input == "exit" || input == "quit")
              break
            end
            if input == "clear"
              puts "Clearing context..."
              Context.delete_context()
              next
            end
            options_and_input = HandleArgs.handle_args()
            context = Context.load_context()
            puts "\n"
            Context.save_context(Prompt.stream_prompt(input, context))
            puts "\n"
          end
          puts "Exiting..."
          #Context.delete_context()
        when "simple"
          if !input.nil?
            Prompt.stream_prompt(input)
          else
            puts "No input given."
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
      puts "Setting API key..."
      puts "Enter API key: (or press enter to exit)"

      while input = Readline.readline("> ", true) do
        if input.empty?
          puts "Exiting."
          exit
        else
          api_key = input.strip
          break
        end
      end
      puts "Saving API key..."
    end

    FileUtils.mkdir_p(File.dirname(CONFIG_PATH))
    File.open(CONFIG_PATH, "w") do |f|
      f.write(YAML.dump({ "OPENAI_API_KEY" => api_key }))
    end
    puts "API key saved."
  end

  def self.load_env()
    YAML.load(File.read(CONFIG_PATH))

  rescue Errno::ENOENT
    puts "No config.yml found."
  end
end

