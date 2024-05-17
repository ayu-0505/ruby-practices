# frozen_string_literal: true

require 'etc'

class FileData
  attr_reader :base_name

  def initialize(path)
    @base_name = File.basename(path)
    @file_status = File.lstat(path)
  end

  def type
    @file_status.ftype
  end

  def mode
    @file_status.mode.to_s(8)
  end

  def nlink
    @file_status.nlink
  end

  def user_name
    Etc.getpwuid(@file_status.uid).name
  end

  def group_name
    Etc.getgrgid(@file_status.gid).name
  end

  def size
    @file_status.size
  end

  def mtime
    @file_status.mtime
  end

  def blocks
    @file_status.blocks
  end
end
