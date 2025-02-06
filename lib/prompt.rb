require "openai"
require_relative './files.rb'
require_relative './config.rb'

class Prompt
  extend Files, Config, Logging
  ## Streams the response, VERY NICE
  def self.stream_prompt(input, conversation = '', temp = load_temperature())
    if temp.nil?
      temp = 0.7
    end
    if conversation.length == 0
      conversation += input
    else
      conversation += "\n My question: #{input}"
    end
    model = load_model()
    if model.nil?
      model = "gpt-4o-mini"
    end
    response = ''
    unless client.nil?
      client.chat(
        parameters: {
          model: model,
          messages: [{ role: "user", content: conversation}],
          temperature: temp,
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

  def self.whisper_translate(file_path, interactive = false)
    if (file_path.nil? || !file_path.end_with?(*['.mp3', '.wav', '.m4a', '.webm', '.mpeg', '.mpga']))
      log("No file given or wrong file type")
      unless interactive
        exit
      end
    else
      size = File.size(file_path).to_f / 2**20
      if size > 24
        warning("The file is above the maximum size of 25MB")
        unless interactive
          exit
        end
      else
        unless client.nil?
          response = client.audio.translate(
          parameters: {
              model: "whisper-1",
              file: File.open(file_path, "rb"),
          })
          if (response["text"].nil? || response["text"].empty?)
            log("No text found")
            unless interactive
              exit
            end
          end
          return response["text"]
        end
      end
    end
  rescue Errno::ENOENT => e
    log(e)
  end

  def self.whisper_transcribe(file_path, interactive = false)
    if (file_path.nil? || !file_path.end_with?(*['.mp3', '.wav', '.m4a', '.webm', '.mpeg', '.mpga']))
      log("No file given")
      unless interactive
        exit
      end
    else
      size = File.size(file_path).to_f / 2**20
      if size > 24
        warning("The file is above the maximum size of 25MB")
        unless interactive
          exit
        end
      else
        unless client.nil?
          response = client.audio.transcribe(
          parameters: {
              model: "whisper-1",
              file: File.open(file_path, "rb"),
          })
          if (response["text"].nil? || response["text"].empty?)
            log("No text found")
            unless interactive
              exit
            end
          end
          return response["text"]
        end
      end
    end
  rescue Errno::ENOENT => e
    #Logging.log("File not found")
    log(e)
  end

  def self.debug_prompt(input)
    model = load_model()
    if model.nil?
      model = "gpt-4o-mini"
    end
    response = client.chat(
      parameters: {
        model: model,
        messages: [{ role: "user", content: input}],
        temperature: 0.7
      }
    )
    log(response)
  end

  def self.list_models()
    arr = []
    client.models.list["data"].each do |m|
      arr << m["id"]
    end
    arr
  end
  private

  def self.client()
    conf = YAML.load(File.read(config_path))
    unless (conf == false || conf.nil?)
      key = conf["OPENAI_API_KEY"]
    end

    begin
      OpenAI::Client.new(access_token: key)
    rescue OpenAI::ConfigurationError => e
      log("OpenAI API key not found, run 'config key' to set it")
      return nil
    end
  end
end
