class FileFormatError < StandardError

  def initialize(msg="File format not supported")
    super
  end

end
