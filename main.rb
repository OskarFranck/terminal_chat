#!/usr/bin/env ruby

require 'fileutils'
require_relative './prompt.rb'
require_relative './handle_args.rb'
require_relative './help.rb'
#['fileutils', './prompt.rb', './handle_args.rb', './help.rb'].each { |f| require f }

class Main

  def self.run()
    context = load_context()
    #puts FileUtils.pwd()
    options_and_input = HandleArgs.handle_args()
    options = options_and_input.select { |k, v| k.start_with?("option_") }
    input = options_and_input["input"]

    puts "Options: #{options}"
    puts "Input: #{input}"

    options.each do |k, v|
      if v == "-f" || v == "--file"
        #Prompt.stream_prompt(input)
      else
      end
    end
    if input.nil?
      puts "No input given."
      Help.display_help()
    else
      save_context(Prompt.tmp_test(input))
      #context = Prompt.stream_prompt(input)
    end

  end

  ## Here we load the file that contains the context.
  ## This need to be parsed to something we can pass to the prompt.
  ## Also the file should only be allowed contain 10 lines. 
  def self.load_context()
    #context = File.read("./context.jsonl")
    context = File.readlines("./context.jsonl").map.with_index do |line, i| 
      if i > 10
        line.chomp!
      end
      JSON.parse(line)
    end

    puts context.length
    return context
  end

  def self.save_context(context)
    file = File.open("./context.jsonl")
    if file.readlines.length > 10
      file.readlines.delete_at(1)
    end
    File.open("./context.jsonl", "a") { |file| file.write("#{context.to_json}\n") }
  end

  def self.delete_context()
    File.truncate("./context.jsonl", 0)
  end
end

Main.run()

