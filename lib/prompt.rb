require "openai"

class Prompt

  ## Streams the response, VERY NICE
  def self.stream_prompt(input, conversation = '', temp = 0.7)
    if conversation.length == 0
      conversation += input
    else
      conversation += "\n My question: #{input}"
    end

    response = ''
    client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: conversation}],
        temperature: temp, ## Should be a parameter
        stream: proc do |chunk, _bytesize|
          response += chunk.dig("choices", 0, "delta", "content") unless chunk.dig("choices", 0, "delta", "content").nil?
          print chunk.dig("choices", 0, "delta", "content")
        end
      }
    )
    context = {
      "input" => input,
      "response" => response,
    }
    return context
  end
  
  ## There is yet no way to pass a general file to the API, only fine-tune
  ## But we can transform the file to a string and pass it to the API
  def self.file_prompt(file_path)
    #file = File.read(file_path)
    file = file_path
    puts "Reading file", file_path
    #accept_warning = false

    #if file.length > 6
    #   accept_warning = warning("The file is longer than 6000 characters, this may take a while")
    #else 
    #  accept_warning = true
    #end

    #if accept_warning
    #  ## Feed the file to the API
    #else
    #  puts "Aborting"
    #end
    return file
  end

  ## Not implemented only scaffolding
  def self.file_finetune()
    return
    client.files.upload(parameters: { file: "./test.json", purpose: "fine-tune" })
    client.files.lisr
    client.files.retrieve(id: "file-123")
    client.files.content(id: "file-123")
    client.files.delete(id: "file-123")
  end
  ## Not implemented only scaffolding
  def self.whisper_translate(file_path)
    size = File.size(file_path).to_f / 2**20
    if size > 24
      warning("The file is above the maximum size of 25MB")
      exit
    else
      response = client.audio.translate(
      parameters: {
          model: "whisper-1",
          file: File.open(file_path, "rb"),
      })
      puts response["text"]
    end
  rescue Errno::ENOENT => e
    puts "File not found"
  end
  ## Not implemented only scaffolding
  def self.whisper_transcribe(file_path)
    size = File.size(file_path).to_f / 2**20
    if size > 24
      warning("The file is above the maximum size of 25MB, this may take")
      exit
    else
      response = client.audio.transcribe(
      parameters: {
          model: "whisper-1",
          file: File.open(file_path, "rb"),
      })
      puts response["text"]
    end
  rescue Errno::ENOENT => e
    puts "File not found"
  end

  private

#  def self.warning(text)
#    accept_warning = false
#    while !accept_warning
#      puts "Warning: #{text}"
#      puts "Do you want to continue? (y)es / (n)o"
#      answer = gets.chomp
#      if answer == "y" || answer == "yes"
#        accept_warning = true
#        return true
#      elsif answer == "n" || answer == "no"
#        puts "Aborting"  
#        return false
#      else
#        puts "Please answer y or n"
#      end
#    end
#  end

  def self.client()
    conf = YAML.load(File.read(CONFIG_PATH))
    key = conf["OPENAI_API_KEY"]

    OpenAI::Client.new(access_token: key)
  end
end
