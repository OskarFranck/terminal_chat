require_relative './files.rb'

module Config
  extend Files
  def load_key()
    config = YAML.load_file(config_path)
    config['OPENAI_API_KEY']
  end

  def save_key(api_key)
    config = YAML.load_file(config_path)
    if config == false
      config = {}
    end
    config['OPENAI_API_KEY'] = api_key
    File.open(config_path, 'w') { |f| YAML.dump(config, f) }
  end

  def load_temperature
    config = YAML.load_file(config_path)
    unless config == false
      config['TEMPERATURE']
    end
  end

  def save_temperature(temperature)
    config = YAML.load_file(config_path)
    if config == false
      config = {}
    end
    config['TEMPERATURE'] = temperature.to_f
    File.open(config_path, 'w') { |f| YAML.dump(config, f) }
  end

  def load_context_length
    config = YAML.load_file(config_path)
    unless config == false
      config['CONTEXT_LENGTH']
    end
  end

  def save_context_length(context_length)
    config = YAML.load_file(config_path)
    if config == false
      config = {}
    end
    config['CONTEXT_LENGTH'] = context_length.to_i
    File.open(config_path, 'w') { |f| YAML.dump(config, f) }
  end

  def set_config(value)
    if value.include?('key')
      stript_value = value.sub(/^key/, '').strip
      if stript_value.empty?
        return 'No API key given'
      end
      save_key(stript_value)
      return 'API key saved'
    elsif value.include?('temp')
      stript_value = value.sub(/^temp/, '').strip.to_f
      if stript_value.to_f > 1.0 || stript_value.to_f < 0.1
        return 'Temperature must be between 0.1 and 1.0'
      end
      save_temperature(stript_value)
      return 'Temperature saved'
    elsif value.include?('context')
      stript_value = value.sub(/^context/, '').strip.to_i
      if stript_value.to_i > 100 || stript_value.to_i < 1
        return 'Context length must be between 1 and 100'
      end
      save_context_length(stript_value)
      return 'Context length saved'
    else
      return 'Invalid config value'
    end
  end

  def set_key(api_key: nil)
    if api_key.nil?
      log("Setting API key...")
      log("Enter API key: (or press enter to exit)")

      while input = Readline.readline("> ", true) do
        if input.empty?
          log("Exiting.")
          exit
        else
          api_key = input.strip
          break
        end
      end
      log("Saving API key...")
    end

    FileUtils.mkdir_p(File.dirname(config_path))
    File.open(config_path, "w") do |f|
      f.write(YAML.dump({ "OPENAI_API_KEY" => api_key }))
    end
    log("API key saved.")
    log("")
  end

  def load_env()
    #Config.load_key()
    YAML.load(File.read(config_path))

  rescue Errno::ENOENT
    log("No config.yml found.")
  end
end
