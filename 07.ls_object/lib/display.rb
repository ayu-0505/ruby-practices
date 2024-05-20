# frozen_string_literal: true

require_relative 'file_data'
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
class Display
  def initialize(paths)
    @files = paths.map { |path| FileData.new(path) }
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
    max_sizes = find_max_sizes
    total = "total #{total_blocks}"
    render_files = @files.map { |file| build_data(file, max_sizes) }.map { |file| format_row(file) }
    [total, render_files]
  end

  private

  def max_base_name_width
    @files.map { |file| file.base_name.size }.max
  end

  def base_names
    @files.map(&:base_name)
  end

  def count_files
    @files.count
  end

  def render_lines(formated_files, row_number)
    render_lines = []
    formated_files.each_slice(row_number) { |file| render_lines << file }
    render_lines.transpose.map { |line| line.join.rstrip }.join("\n")
  end

  def find_max_sizes
    {
      size: max_size_width,
      nlink: max_nlink_width,
      user: max_user_width,
      group: max_group_width
    }
  end

  def max_size_width
    @files.map { |file| file.size.to_i }.max.to_s.size
  end

  def max_nlink_width
    @files.map { |file| file.nlink.to_i }.max.to_s.size
  end

  def max_user_width
    @files.map { |file| file.user_name.size }.max
  end

  def max_group_width
    @files.map { |file| file.group_name.size }.max
  end

  def total_blocks
    @files.sum(&:blocks)
  end

  def build_data(file, max_sizes)
    {
      type: convert_type(file.type),
      mode: convert_mode(file.mode),
      nlink: resize_nlink(file.nlink, max_sizes),
      user: resize_user(file.user_name, max_sizes),
      group: resize_group(file.group_name, max_sizes),
      size: resize_byte_size(file.size, max_sizes),
      mtime: convert_modify_time(file.mtime),
      base_name: file.base_name
    }
  end

  def convert_type(type)
    FILETYPES[type]
  end

  def convert_mode(mode)
    (-3..-1).map { |num| MODE_TABLE[mode[num]] }.join
  end

  def resize_nlink(nlink, max_sizes)
    nlink.to_s.rjust(max_sizes[:nlink])
  end

  def resize_user(user, max_sizes)
    user.ljust(max_sizes[:user])
  end

  def resize_group(group, max_sizes)
    group.ljust(max_sizes[:group])
  end

  def resize_byte_size(size, max_sizes)
    size.to_s.rjust(max_sizes[:size])
  end

  def convert_modify_time(time)
    time.strftime('%_m %e %R')
  end

  def format_row(data)
    [
      data[:type],
      data[:mode],
      "  #{data[:nlink]}",
      " #{data[:user]}",
      "  #{data[:group]}",
      "  #{data[:size]}",
      " #{data[:mtime]}",
      " #{data[:base_name]}"
    ].join
  end
end
