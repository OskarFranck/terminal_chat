class HandleArgs
  def self.permitted_options()
    ## TODO: Add more options.
    ## -t --translate
    ## -temp --temperature (need to handle value after input)

    [
      '-h',
      '--help',
      '-v',
      '--version',
      '-f',
      '--file',
      '-lf',
      '--loadfile',
      '-d',
      '--delete',
      '-c',
      '--conversation',
      '--finetune',
      '-w', '--whisper',
      '-t', '--translate',
      '-i', '--interactive',
      '--key',
  ]
end

  def self.handle_args()
    p_args = HandleArgs.permitted_options()
    ## This is the hash that will be returned.
    args_hash = {}

    ## This handles args then called as ruby script.
    ARGV.each_with_index do |arg, i|
      #Logging.log("Arg: #{arg}")

      if arg.start_with?('-')
        ## This is an option.
        if p_args.include?(arg)
          ## This is a permitted / available option.
          #Logging.log("Option: #{arg}")
          args_hash["option_#{i}"] = arg
        else
          ## This is an unknown option.
          ## TODO: Handle unknown option. display help? discard?
          Logging.log("Unknown option: #{arg}")
          args_hash["option_#{i}"] = arg
        end
      else
        ## This is input.
        ## This if statement append all 'input' args to one string.
        if args_hash["input"].nil?
          args_hash["input"] = arg
        else
          args_hash["input"] = "#{args_hash['input']} #{arg}"
        end
      end
    end
    return args_hash
  end
end
