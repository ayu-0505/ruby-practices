# frozen_string_literal: true

require 'etc'

class FileStatus
  attr_reader :path

  def initialize(path)
    @path = path
    @status = File.lstat(path)
  end

  def type
    @status.ftype
  end

  def mode
    @status.mode.to_s(8)
  end

  def nlink
    @status.nlink
  end

  def user_name
    Etc.getpwuid(@status.uid).name
  end

  def group_name
    Etc.getgrgid(@status.gid).name
  end

  def size
    @status.size
  end

  def mtime
    @status.mtime
  end

  def blocks
    @status.blocks
  end
end
