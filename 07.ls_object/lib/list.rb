# frozen_string_literal: true
require_relative 'file_data'

class List
attr_reader :file_datas

  def initialize(paths)
    @file_datas = paths.map do |path|
      FileData.new(path)
    end
  end

  def file_name_width
    @file_datas.map(&:filename).map(&:size).max
  end

  def size_width
    @file_datas.map(&:size).max.to_s.size
  end

  def hard_link_width
    @file_datas.map(&:hard_link).max.to_s.size
  end

  def uid_name_width
    @file_datas.map(&:user_name).map(&:size).max
  end

  def gid_name_width
    @file_datas.map(&:group_name).map(&:size).max
  end
end
