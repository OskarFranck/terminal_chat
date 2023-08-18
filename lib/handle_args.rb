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
    '-d',
    '--delete',
    '-c',
    '--conversation',
    '--finetune',
    '--install'
  ]
end

def self.handle_args()
  p_args = HandleArgs.permitted_options()
  ## This is the hash that will be returned.
  args_hash = {}

  ## This handles args when it passed through the command line (bash function that starts the script).
  ## Should probably be handle them in a more general way.
  args_arr = ARGV[0].split(' ')
  args_arr.each_with_index do |arg, i|

    ## This handles args then called as ruby script.
    #ARGV.each_with_index do |arg, i|
      #puts "Arg: #{arg}"

      if arg.start_with?('-')
        ## This is an option.
        if p_args.include?(arg)
          ## This is a permitted / available option.
          #puts "Option: #{arg}"
          args_hash["option_#{i}"] = arg
        else
          ## This is an unknown option.
          ## TODO: Handle unknown option. display help? discard?
          puts "Unknown option: #{arg}"
          args_hash["option_#{i}"] = arg
        end
      else
        ## This is input.
        ## TODO: Handle input.
        #puts "Argument: #{arg}"
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
