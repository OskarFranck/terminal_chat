Gem::Specification.new do |s|
  s.name = "ask-ai"
  s.version = "0.0.2"
  s.summary = "A simple CLI for OpenAI's GPT-3 API."
  s.description = "A CLI tool for using OpenAI's API. The idea is to make it easy to use the API with an option to pass files for help with diffrent tasks."
  s.authors = ["Oskar Franck"]
  s.email = "contact.oskarfranck.se"
  s.homepage = "https://github.com/OskarFranck/terminal_chat"
  s.license = "MIT"
  # This includes all files under the lib directory recursively, so we don't have to add each one individually.
  s.files     = Dir.glob("{lib,bin,files,config}/**/*")
  s.require_path = 'lib'
  s.add_dependency 'ruby-openai', '~> 5.1.0'
  s.executables = ['ask-ai']
end

