#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'
['./prompt.rb', './handle_args.rb', './help.rb', './context.rb'].each { |f| require_relative f }

#CONTEXT_PATH = File.expand_path(File.dirname(__FILE__)) + "/./files/context.jsonl"
CONTEXT_PATH = File.expand_path("./../files/context.jsonl", __dir__)
CONFIG_PATH = File.expand_path("./../config/config.yml", __dir__)
class Main

  def self.run()
    config = load_env()
  
    if config['OPENAI_API_KEY'].nil?
      puts "No API key found."
      Help.display_api_key()
      exit
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
            exec("touch ./config/config.yml")
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
          puts 'File'
          file_path = input
          puts Prompt.file_prompt(file_path)
        when "-d", "--delete"
          if input.nil?
            Context.delete_context()
          else
            Context.delete_context()
            Context.save_context(Prompt.stream_prompt(input, context))
          end
        when "-c", "--conversation"
          Context.save_context(Prompt.stream_prompt(input, context))
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
  end
end

Main.run()

