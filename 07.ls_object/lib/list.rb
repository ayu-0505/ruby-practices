# frozen_string_literal: true

require_relative 'file_data'

class List
  attr_reader :file_datas

  def initialize(paths)
    @file_datas = paths.map { |path| FileData.new(path) }
  end

  def max_file_name_width
    @file_datas.map(&:filename).map(&:size).max
  end

  def max_size_width
    @file_datas.map(&:size).map(&:to_i).max.to_s.size
  end

  def max_nlink_width
    @file_datas.map(&:nlink).map(&:to_i).max.to_s.size
  end

  def max_user_width
    @file_datas.map(&:user_name).map(&:size).max
  end

  def max_group_width
    @file_datas.map(&:group_name).map(&:size).max
  end

  def count_file_datas
    @file_datas.count
  end

  def total_blocks
    @file_datas.sum(&:blocks)
  end
end
