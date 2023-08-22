#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'
['./prompt.rb', './handle_args.rb', './help.rb', './context.rb'].each { |f| require_relative f }

#CONTEXT_PATH = File.expand_path(File.dirname(__FILE__)) + "/./files/context.jsonl"
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
    end

    context = Context.load_context()
    options_and_input = HandleArgs.handle_args()
    options = options_and_input.select { |k, v| k.start_with?("option_") }
    input = options_and_input["input"]

    halt_options = ["-h", "--help", "-v", "--version", "--install"]

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
        when "-i", "--install"
          puts "Installing..."
          unless File.exist?(CONFIG_PATH)
            puts 'Creating config.yml...'
            File.open(CONFIG_PATH, 'w') { |f| f.write("OPENAI_API_KEY: ") }
          end
          puts "Installing dependencies..."
          exec("bundle install")
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
            puts "No file found."
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
          Context.save_context(Prompt.stream_prompt(input, context))
        when "-w", "--whisper"
          puts Prompt.whisper_transcribe(input)
        when "-t", "--translate"
          puts Prompt.whisper_translate(input)
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

  def self.load_env()
    YAML.load(File.read(CONFIG_PATH))

  rescue Errno::ENOENT
    puts "No config.yml found."
  end
end

Main.run()

