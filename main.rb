#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'
['./lib/prompt.rb', './lib/handle_args.rb', './lib/help.rb', './lib/context.rb'].each { |f| require_relative f }

class Main

  def self.run()
    config = load_env()
  
    ## Not secure to store API key in config.yml
    if config['OPENAI_API_KEY'].nil?
      puts "No API key found."
      Help.display_api_key()
      exit
    end

    context = Context.load_context()
    options_and_input = HandleArgs.handle_args()
    options = options_and_input.select { |k, v| k.start_with?("option_") }
    input = options_and_input["input"]

    #puts "Options: #{options}"
    #puts "Input: #{input}"

    halt_options = ["-h", "--help", "-v", "--version"]

    ## Hack... Need to fix this.
    ## Descriped in README.md
    if options.empty?
      ## No options given.
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
    YAML.load(File.read("./config/config.yml"))
  end
end

Main.run()

