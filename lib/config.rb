require_relative './files.rb'

module Config
  include Files
  def self.load_key()
    config = YAML.load_file(Files.config_path)
    config['OPENAI_API_KEY']
  end

  def self.save_key(api_key)
    config = YAML.load_file(Files.config_path)
    config['OPENAI_API_KEY'] = api_key
    File.open(Files.config_path, 'w') { |f| YAML.dump(config, f) }
  end

  def self.load_temperature
    config = YAML.load_file(Files.config_path)
    config['TEMPERATURE']
  end

  def self.save_temperature(temperature)
    config = YAML.load_file(Files.config_path)
    config['TEMPERATURE'] = temperature.to_f
    File.open(Files.config_path, 'w') { |f| YAML.dump(config, f) }
  end

  def self.load_context_length
    config = YAML.load_file(Files.config_path)
    config['CONTEXT_LENGTH']
  end

  def self.save_context_length(context_length)
    config = YAML.load_file(Files.config_path)
    config['CONTEXT_LENGTH'] = context_length.to_i
    File.open(Files.config_path, 'w') { |f| YAML.dump(config, f) }
  end

  def self.set_config(value)
    puts 'value',value
    if value.include?('key')
      stript_value = value.sub(/^key/, '').strip
      if stript_value.empty?
        puts 'No API key given'
        exit
      end
      save_key(stript_value)
    elsif value.include?('temp')
      stript_value = value.sub(/^temp/, '').strip
      if stript_value.empty?
        puts 'No temperature given'
        exit
      end
      save_temperature(stript_value)
    elsif value.include?('context')
      stript_value = value.sub(/^context/, '').strip
      if stript_value.empty?
        puts 'No context length given'
        exit
      end
      save_context_length(stript_value)
    else
      puts 'Invalid config value'
    end
  end
end
