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

    #puts "Options: #{options}"
    #puts "Input: #{input}"

    #puts context
  
    if context.length > 0
      context_as_string = "This is our previous conversation:\n"
    else
      context_as_string = ""
    end

    ## This is a bit hacky, but it almost works it append all text every time.
    if context.length > 0
      context.each_with_index do |v, i|
        #puts 'v',v['input']
        context_as_string += "My #{i + 1} input was: #{v['input']}\nYour #{i + 1} response was: #{v['response']}\nNow I ask: #{input}\n"
      end
    else
      context_as_string += "Now I ask: #{input}\n"
    end

    puts '#'*80
    puts context_as_string
    puts '#'*80
    #case options
    #when "-h", "--help"
    #  Help.display_help()
    #when "-v", "--version"
    #  Help.display_version()
    #when "-f", "--file"
    #  Prompt.file_prompt(input)
    #when "-d", "--delete"
    #  delete_context()
    #else
    #  if input.nil?
    #    Help.display_help()
    #  else
    #    save_context(Prompt.tmp_test(input))
    #    #save_context(Prompt.stream_prompt(input))
    #  end
    #end



    options.each do |k, v|
      #puts "k: #{k}, v: #{v}"
      if v == "-f" || v == "--file"
        #Prompt.stream_prompt(input)
      elsif v == "-d" || v == "--delete"
        delete_context()
      else
        puts "Unknown option: #{v}"
        Help.display_help()
      end
    end
    if input.nil?
      puts "No input given."
      #Help.display_help()
    else
      #save_context(Prompt.tmp_test(input))
      save_context(Prompt.stream_prompt(context_as_string))
    end

  end

  ## Here we load the file that contains the context.
  ## This need to be parsed to something we can pass to the prompt.
  ## Also the file should only be allowed contain 10 lines. 
  def self.load_context()
    File.readlines("./context.jsonl").map { |line| JSON.parse(line) } 
  end

  def self.save_context(context)
    tmp_arr = []
    File.readlines("./context.jsonl").map { |line| tmp_arr.push(JSON.parse(line)) }
    if tmp_arr.length > 9
      tmp_arr.shift()
    end
    File.truncate("./context.jsonl", 0)
    tmp_arr.each { |line| File.open("./context.jsonl", "a") { |file| file.write("#{line.to_json}\n") } }
    File.open("./context.jsonl", "a") { |file| file.write("#{context.to_json}\n") }
  end

  def self.delete_context()
    puts "Deleting previous context."
    File.truncate("./context.jsonl", 0)
  end
end

Main.run()

