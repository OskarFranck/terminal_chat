require_relative './files.rb'
require_relative './config.rb'
require_relative './file_format_error.rb'
class Context
  extend Files, Config, Logging
  def self.load_context(file_with_context: false)
    if File.exist?(context_path)
      conversation = File.readlines(context_path).map { |line| JSON.parse(line) }
    else
      conversation = []
    end

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

    if file_with_context
      return load_context_file() + context_as_string
    end

    return context_as_string
  end

  ## Here we save the context to a file.
  ## Max 10 previous Q / A to save tokens.
  def self.save_context(context)
    return if context.nil?
    tmp_arr = []
    unless File.exist?(context_path)
      File.open(context_path, "w") {}
    end
    File.readlines(context_path).map { |line| tmp_arr.push(JSON.parse(line)) }
    length = load_context_length().nil? ? 10 : load_context_length()
    if tmp_arr.length > length
      tmp_arr.shift()
    end
    File.truncate(context_path, 0)
    tmp_arr.each { |line| File.open(context_path, "a") { |file| file.write("#{line.to_json}\n") } }
    File.open(context_path, "a") { |file| file.write("#{context.to_json}\n") }
  end

  def self.delete_context()
    File.truncate(context_path, 0)
    log("Previous context deleted.")
  end

  def self.save_context_file(file_path)
    ## If the file extenstion is pdf or docx raise an error.
    ## This is not a complete list of file extensions.
    if file_path.include?(".pdf") || file_path.include?(".docx")
      raise FileFormatError, "File type not supported."
    end
    unless file_path.nil?
      conter = 0
      file_in = File.open(file_path, 'r')
      file_out = File.open(context_file_path, 'a')
      file_out.write("loaded_context_file_path=#{file_path}\n")
      char_count = 0
      file_in.each do |line|
        #puts "Line: #{line}"
        char_count += line.length
        file_out.write(line)
      end
      file_in.close
      file_out.close

      if char_count > 10000
        log("Warning: The file you are trying to feed to the API is #{char_count} characters long. This consumes a lot of tokens.")
      end
    else
      log("No file path given.")
    end
  rescue Errno::ENOENT
    log("No file at '#{file_path}' found.")
  rescue FileFormatError => e
    log(e.message)
  end

  def self.load_context_file()
    file = File.open(context_file_path, 'r')
    file_as_string = ""
    file.each do |line|
      file_as_string += line
    end

    return file_as_string
  rescue Errno::ENOENT
    log("No file at '#{context_file_path}' found.")
    log("Load a file with '-lf <file_path>'")
    return ""
  end
  ## This first class pasta method need to be refactored.
  ## It's a mess.
  def self.delete_file_context()
    counter = 1
    delete_lines = []
    last_line = 0
    File.open(context_file_path, "r") { |file|
      if file.size == 0
        log("No files loaded.")
        return
      end
      file.readlines.each_with_index { |line, index|
        if line.include?("loaded_context_file_path=")
          log("#{counter}: #{line.gsub("loaded_context_file_path=", "")}")
          delete_lines.push(index)
          counter += 1
        end
        last_line = index
      }
    }
    if counter == 1 + 1
      log "One file loaded. Enter '1' or 'all' to delete it."
      log "Enter 'a' to abort."
    else
      log("Which file do you want to delete? (1, #{counter - 1}) or 'all'")
      log("Enter 'a' to abort.")
    end
  
    delete_counter = 0
    while input = Readline.readline("\nDelete --> ", true) do
      if input == "a"
        log("Aborting.")
        return
      elsif input == "all"
        File.truncate(context_file_path, 0)
        log("Deleted all files.")
        return
      elsif input.to_i >= 1 && input.to_i < counter
        lines_to_save = []
        File.open(context_file_path, "r") { |file|
          file.readlines.each_with_index { |line, index|
            start_line = delete_lines[input.to_i - 1]
            end_line = delete_lines[input.to_i]
            if end_line.nil?
              end_line = last_line + 1
            end
            if index < start_line || index > end_line - 1
              lines_to_save.push(line)
            end
          }
        }
        File.truncate(context_file_path, 0)
        File.open(context_file_path, "a") { |file|
          lines_to_save.each { |line|
            file.write(line)
          }
        }
        log("Deleting file")
        return
      elsif input.to_i <= 0 || input.to_i > counter
        log("Please enter a number between 1 and #{counter - 1}")
        log("Enter 'a' to abort.")
      else
        log("This is a feature, not a bug")
      end
    end
  end

end
