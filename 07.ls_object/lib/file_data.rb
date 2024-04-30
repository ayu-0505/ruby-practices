# frozen_string_literal: true

class FileData
  attr_reader :filename

  def initialize(filename, path = nil)
    @filename = filename
    @file_info = File.lstat(path) unless path.nil?
  end

  def filename_length
    @filename.size
  end

  def type
    @file_info.ftype
  end

  def permission_mode
    @file_info.mode.to_s(8)
  end

  def hard_link
    @file_info.nlink
  end

  def user_id
    @file_info.uid
  end

  def group_id
    @file_info.gid
  end

  def size
    @file_info.size
 end

 def modify_time
    @file_info.mtime
 end
end
