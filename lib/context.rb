require_relative './files.rb'
require_relative './config.rb'
class Context
  extend Files, Config, Logging
  def self.load_context()
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
    log("Deleting previous context.")
    File.truncate(context_path, 0)
  end

  def self.save_context_file(file_path)
    unless file_path.nil?
      file_in = File.open(file_path, 'r')
      file_out = File.open(context_file_path, 'w')
      char_count = 0
      file_in.each do |line|
        puts "Line: #{line}"
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
    log("Load a file with 'aa -lf <file_path>'")
    return ""
  end

end
