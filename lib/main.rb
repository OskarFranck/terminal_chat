#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'
require 'readline'
require 'io/console'
require_relative './logging.rb'
require_relative './prompt.rb'
require_relative './help.rb'
require_relative './context.rb'
require_relative './files.rb'
require_relative './config.rb'

class Main
  extend Logging, Files, Config
  LIST = [
    "exit", "quit", "version", "clear", "help", "show",
    "-w", "-t", "-lf", "-f", "-df", "config", "temp", "context"
  ].sort

  def self.run()

    ## When using Readline, TAB will auto-complete
    ## But it will only auto-complete from the LIST
    ## Need to handle directories and files when -lf, -w, -t are used
    #comp = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }
    #Readline.completion_append_character = ""
    #Readline.completion_proc = comp

    ## Function that when called activates completion from LIST
    # def self.list_auto_complete()
    #   Readline.completion_append_character = ""
    #   Readline.completion_proc = proc do |s|
    #     if s.start_with?("-w", "-t", "-lf", "-f")
    #       pattern = s.sub(/^-w/, "") + "*"
    #       Dir.glob(pattern).grep(/^#{Regexp.escape('')}/)
    #     else
    #       LIST.grep(/^#{Regexp.escape(s)}/)
    #     end
    #   end
    # end

    # list_auto_complete()

    Help.interactive_desc()
    while input = Readline.readline("\n> ", true) do
      case input
      when "exit", "quit"
        break
      when "version"
        Help.display_version()
      when "clear"
        log("Clearing context...")
        Context.delete_context()
      when 'help'
        Help.interactive_desc()
      when /^help/
        strip_input = input.sub(/^help/, "").strip
        Help.interactive_help(strip_input)
      when "show"
        log("\n")
        log(Context.load_context())
      when /^-w/ 
        stript_input = input.sub(/^-w/, "").strip
        log(Prompt.whisper_transcribe(stript_input, interactive: true))
      when /^-t/
        stript_input = input.sub(/^-t/, "").strip
        log(Prompt.whisper_translate(stript_input, interactive: true))
      when /^-lf/
        stript_input = input.sub(/^-lf/, "").strip
        log("Loading File #{stript_input}")
        Context.save_context_file(stript_input)
      when /^-df/
        Context.delete_file_context()
      when /^-f/
        stript_input = input.sub(/^-f/, "").strip
        file_as_string = Context.load_context_file()
        if file_as_string.empty?
          log("No file loaded.")
          next
        end
        context = Context.load_context(file_with_context: true)
        log("")
        Context.save_context(Prompt.stream_prompt(stript_input, context))
        log("")
      when ""
        log("No input given.")
      when /^config/
        strip_input = input.sub(/^config/, "").strip
        res = set_config(strip_input)
        if res.is_a?(String)
          log(res)
        end
      else
        context = Context.load_context()
        log("")
        Context.save_context(Prompt.stream_prompt(input, context))
        log("")
      end
    end
  end
end

