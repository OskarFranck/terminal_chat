class Context
  def self.load_context()
    conversation = File.readlines(CONTEXT_PATH).map { |line| JSON.parse(line) }

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
    tmp_arr = []
    File.readlines(CONTEXT_PATH).map { |line| tmp_arr.push(JSON.parse(line)) }
    if tmp_arr.length > 9
      tmp_arr.shift()
    end
    File.truncate(CONTEXT_PATH, 0)
    tmp_arr.each { |line| File.open(CONTEXT_PATH, "a") { |file| file.write("#{line.to_json}\n") } }
    File.open(CONTEXT_PATH, "a") { |file| file.write("#{context.to_json}\n") }
  end

  def self.delete_context()
    puts "Deleting previous context."
    File.truncate(CONTEXT_PATH, 0)
  end

  def self.save_context_file(file_path)
    file_in = File.open(file_path, 'r')
    file_out = File.open(CONTEXT_FILE_PATH, 'w')
    char_count = 0
    file_in.each do |line|
      char_count += line.length
      file_out.write(line)
    end

    if char_count > 10000
      puts "Warning: The file you are trying to feed to the API is #{char_count} characters long. This consumes a lot of tokens."
    end

  rescue Errno::ENOENT
    puts "No file at '#{file_path}' found."
  end

  def self.load_context_file()
    file = File.open(CONTEXT_FILE_PATH, 'r')
    file_as_string = ""
    file.each do |line|
      file_as_string += line
    end

    return file_as_string
  rescue Errno::ENOENT
    puts "No file at '#{CONTEXT_FILE_PATH}' found."
    puts "Load a file with 'aa -lf <file_path>'"
    return ""
  end

end
