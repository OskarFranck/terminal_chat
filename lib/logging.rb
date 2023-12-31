require 'logger'

module Logging
  def log(msg)
    logger = Logger.new(STDOUT)
    logger.formatter = proc { |_severity, _datetime, _progname, msg| "#{msg}\n" }
    logger.info(msg)
  end
end
