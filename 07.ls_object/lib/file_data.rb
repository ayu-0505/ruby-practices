# frozen_string_literal: true
require 'etc'

class FileData
  attr_reader :filename

  def initialize(path)
    @filename = File.basename(path)
    @file_info = File.lstat(path)
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

  def user_name
    Etc.getpwuid(@file_info.uid).name
  end

  def group_name
    Etc.getgrgid(@file_info.gid).name
  end

  def size
    @file_info.size
 end

 def modify_time
    @file_info.mtime
 end
end
