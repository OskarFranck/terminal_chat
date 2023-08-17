#!/usr/bin/env ruby

require 'fileutils'
['./prompt.rb', './handle_args.rb', './help.rb', './context.rb'].each { |f| require_relative f }

class Main

  def self.run()
    context = Context.load_context()
    options_and_input = HandleArgs.handle_args()
    options = options_and_input.select { |k, v| k.start_with?("option_") }
    input = options_and_input["input"]

    halt_options = ["-h", "--help", "-v", "--version"]

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
        when "-d", "--delete" && input.nil?
          Context.delete_context()
        when "-d", "--delete" && !input.nil?
          delete_context()
          Context.save_context(Prompt.stream_prompt(input, context))
        when "-c", "--conversation"
          Context.save_context(Prompt.stream_prompt(input, context))
        when "simple" && !input.nil?
          puts 'No option given'
          Prompt.stream_prompt(input)
        else
          Help.display_help()
        end
      end
    end
  end
end

Main.run()

