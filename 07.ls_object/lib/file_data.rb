# frozen_string_literal: true

class FileData
  attr_reader :filename

  def initialize(filename, absolute_path)
    @filename = filename
    @file_info = File.lstat(absolute_path)
  end

  def filename_length
    @filename.size
  end

  # def file_size
  #    @file_info.size
  # end
end
