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

  ## Not implemented only scaffolding
  def self.file_finetune()
    return
    client.files.upload(parameters: { file: "./test.json", purpose: "fine-tune" })
    client.files.lisr
    client.files.retrieve(id: "file-123")
    client.files.content(id: "file-123")
    client.files.delete(id: "file-123")
  end

  def self.whisper_translate(file_path)
    if (file_path.nil? || !file_path.end_with?(*['.mp3', '.wav', '.m4a', '.webm', '.mpeg', '.mpga']))
      puts "No file given or wrong file type"
      exit
    else
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
        if (response["text"].nil? || response["text"].empty?)
          puts "No text found"
          exit
        end
        puts response["text"]
      end
    end
  rescue Errno::ENOENT => e
    puts "File not found"
  end

  def self.whisper_transcribe(file_path)
    if (file_path.nil? || !file_path.end_with?(*['.mp3', '.wav', '.m4a', '.webm', '.mpeg', '.mpga']))
      puts "No file given"
      exit
    else
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
        if (response["text"].nil? || response["text"].empty?)
          puts "No text found"
          exit
        end
        puts response["text"]
      end
    end
  rescue Errno::ENOENT => e
    puts "File not found"
  end

  private

  def self.client()
    conf = YAML.load(File.read(CONFIG_PATH))
    key = conf["OPENAI_API_KEY"]

    OpenAI::Client.new(access_token: key)
  end
end
