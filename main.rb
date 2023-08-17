#!/usr/bin/env ruby

require 'fileutils'
require_relative './prompt.rb'
require_relative './handle_args.rb'
require_relative './help.rb'
#['fileutils', './prompt.rb', './handle_args.rb', './help.rb'].each { |f| require f }

class Main

  def self.run()
    context = load_context()
    options_and_input = HandleArgs.handle_args()
    options = options_and_input.select { |k, v| k.start_with?("option_") }
    input = options_and_input["input"]
    #puts "Options: #{options}"
    #puts "Input: #{input}"

    halt_options = ["-h", "--help", "-v", "--version", "-f", "--file"]
    continue_to_prompt = true

    options.each do |k, v|
      if halt_options.include?(v)
        continue_to_prompt = false
      end
    end

    ## Maybe this should be a case statement?
    ## but since we have to check for each option this might be better.
    options.each do |k, v|
      #puts "k: #{k}, v: #{v}"
      if v == "-f" || v == "--file"
        file_path = input
        puts Prompt.file_prompt(file_path)
      elsif v == "-d" || v == "--delete"
        delete_context()
      elsif v == "-v" || v == "--version"
        Help.display_version()
      else
        puts "Unknown option: #{v}"
        Help.display_help()
      end
    end

    # Hack to don't prompt if we have a file.
    #


    ## As of now we always stream the prompt.
    ## But if ex, -h is given we don't want to stream the prompt.
    if !input.nil? && continue_to_prompt
      puts 'streaming prompt'
      save_context(Prompt.stream_prompt(input, context))
    elsif input.nil? && continue_to_prompt
      puts "No input given."
      #Help.display_help()
    else
      #Help.display_help()
    end
  end

  ## Here we load the file that contains the context.
  ## This need to be parsed to something we can pass to the prompt.
  def self.load_context()
    conversation = File.readlines("./context.jsonl").map { |line| JSON.parse(line) }

    if conversation.length > 0
      context_as_string = "This is our previous conversation:\n"
    else
      context_as_string = ""
    end

    if conversation.length > 0
      conversation.each_with_index do |v, i|
        context_as_string += "My #{i + 1} input was: #{v['input']}\nYour #{i + 1} response was: #{v['response']}\n"
      end
    end

    return context_as_string
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

