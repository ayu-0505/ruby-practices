# frozen_string_literal: true

require_relative 'file_data'

class Display
  COLUMN_NUMBER = 3
  SHORT_LIST_PADDING = 7
  FILETYPES = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '_',
    'link' => 'l',
    'socket' => 's'
  }.freeze
  MODE_TABLE = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(paths)
    @files = paths.map { |path| FileData.new(path) }
    # @list = List.new(paths)
  end

  def render_short_list
    width = max_base_name_width + SHORT_LIST_PADDING
    formated_files = base_names.map { |file| file.ljust(width) }
    file_count = count_files
    row_number = (file_count / COLUMN_NUMBER.to_f).ceil
    (COLUMN_NUMBER - (file_count % COLUMN_NUMBER)).times { formated_files << '' } if file_count % COLUMN_NUMBER != 0
    render_lines(formated_files, row_number)
  end

  def render_long_list
    total = "total #{total_blocks}"
    render_files = @files.map { |file| build_data(file) }.map { |file| format_row(file) }
    [total, render_files]
  end

  private

  def base_names
    @files.map(&:base_name)
  end

  def render_lines(formated_files, row_number)
    render_lines = []
    formated_files.each_slice(row_number) { |file| render_lines << file }
    render_lines.transpose.map { |line| line.join.rstrip }.join("\n")
  end

  def build_data(file)
    {
      type: convert_type(file.type),
      mode: convert_mode(file.mode),
      nlink: resize_nlink(file.nlink),
      user: resize_user(file.user_name),
      group: resize_group(file.group_name),
      size: resize_byte_size(file.size),
      mtime: convert_modify_time(file.mtime),
      base_name: file.base_name
    }
  end

  def format_row(data)
    [
      data[:type],
      data[:mode],
      "  #{data[:nlink].rjust(max_nlink_width)}",
      " #{data[:user].ljust(max_user_width)}",
      "  #{data[:group].ljust(max_group_width)}",
      "  #{data[:size].rjust(max_size_width)}",
      " #{data[:mtime]}",
      " #{data[:base_name]}"
    ].join
  end

  def convert_type(type)
    FILETYPES[type]
  end

  def convert_mode(mode)
    (-3..-1).map { |num| MODE_TABLE[mode[num]] }.join
  end

  def resize_nlink(nlink)
    nlink.to_s.rjust(max_nlink_width)
  end

  def resize_user(user)
    user.ljust(max_user_width)
  end

  def resize_group(group)
    group.ljust(max_group_width)
  end

  def resize_byte_size(size)
    size.to_s.rjust(max_size_width)
  end

  def convert_modify_time(time)
    time.strftime('%_m %e %R')
  end

  def max_base_name_width
    @files.map { |file_data| file_data.base_name.size }.max
  end

  def max_size_width
    @files.map { |file_data| file_data.size.to_i }.max.to_s.size
  end

  def max_nlink_width
    @files.map { |file_data| file_data.nlink.to_i }.max.to_s.size
  end

  def max_user_width
    @files.map { |file_data| file_data.user_name.size }.max
  end

  def max_group_width
    @files.map { |file_data| file_data.group_name.size }.max
  end

  def count_files
    @files.count
  end

  def total_blocks
    @files.sum(&:blocks)
  end
end
