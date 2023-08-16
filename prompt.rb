require "openai"


class Prompt

  def self.tmp_test(input)

    return {
      "input" => input,
      "response" => "I asked: Tell me a knock knock joke. You answered: Knock, knock? Whos there? Lettuce. Lettuce who? Lettuce in, its cold out here. What did i you answer last time?"
    }

  end
  ## Streams the response, VERY NICE
  def self.stream_prompt(input)
    response = ''
    client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [{ role: "user", content: input}], # Required.
        temperature: 0.7,
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

  ## Remove? or implement
  def self.reg_prompt(input)
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: "In A VoIP / Phone context translate #{input} to Swedish? I only want the translated word or sentence as response"}],
        temperature: 0.7,
      }
    )
    puts response.dig("choices", 0, "message", "content")
  end

  ## Not implemented only scaffolding
  def self.file_prompt()
    client.files.upload(parameters: { file: "./test.json", purpose: "fine-tune" })
    client.files.list
    client.files.retrieve(id: "file-123")
    client.files.content(id: "file-123")
    client.files.delete(id: "file-123")
  end
  ## Not implemented only scaffolding
  def self.whisper_translate()
    response = client.audio.translate(
    parameters: {
        model: "whisper-1",
        file: File.open("path_to_file", "rb"),
    })
    puts response["text"]
  end
  ## Not implemented only scaffolding
  def self.whisper_transcribe()
    response = client.audio.transcribe(
    parameters: {
        model: "whisper-1",
        file: File.open("path_to_file", "rb"),
    })
    puts response["text"]
  end

  private

  def self.client
    OpenAI::Client.new(access_token: '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')
  end
end
