class Context
  ## Here we load the file that contains the context.
  ## This need to be parsed to something we can pass to the prompt.

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
end
