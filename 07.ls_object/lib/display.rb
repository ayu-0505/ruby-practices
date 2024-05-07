# frozen_string_literal: true
require_relative 'list'

class Display
  COLUMN_NUMBER = 3
  SHORT_LIST_PADDING = 7
  FILETYPES = { 'fifo' => 'p',
              'characterSpecial' => 'c',
              'directory' => 'd',
              'blockSpecial' => 'b',
              'file' => '_',
              'link' => 'l',
              'socket' => 's' }.freeze
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
    @list = List.new(paths)
  end

  def render_short_list
    width = @list.max_file_name_width + SHORT_LIST_PADDING
    formated_files = file_names.map { |file| file.ljust(width) }
    file_count = @list.count_file_datas
    row_number = (file_count / COLUMN_NUMBER.to_f).ceil
    (COLUMN_NUMBER - file_count % COLUMN_NUMBER).times { formated_files << '' } if file_count % COLUMN_NUMBER != 0
    render_lines = []
    formated_files.each_slice(row_number) { |file| render_lines << file }
    render_lines = render_lines.transpose.map {|line| line.join.rstrip }.join("\n")
    render_lines
  end

  def render_long_list
    total = "total #{@list.total_blocks}"
    render_file_datas =  @list.file_datas.map { |file| build_data(file) }.map { |file| format_row(file) }
    [total, render_file_datas]
  end

  private

  def file_names
    @list.file_datas.map(&:filename)
  end

  def build_data(file) # FileDataクラス
    {
      type: convert_type(file.type),
      mode: convert_mode(file.mode),
      nlink: resize_nlink(file.nlink),
      user: resize_user(file.user_name),
      group: resize_group(file.group_name),
      size: resize_byte_size(file.size),
      mtime: convert_modify_time(file.mtime),
      filename: file.filename
    }
  end

  def format_row(data) #data = hash
    [
      data[:type],
      data[:mode],
      "  #{data[:nlink].rjust(@list.max_nlink_width)}",
      " #{data[:user].ljust(@list.max_user_width)}",
      "  #{data[:group].ljust(@list.max_group_width)}",
      "  #{data[:size].rjust(@list.max_size_width)}",
      " #{data[:mtime]}",
      " #{data[:filename]}"
    ].join
  end

  def convert_type(type)
    FILETYPES[type]
  end

  def convert_mode(mode)
    (-3..-1).map {|num| MODE_TABLE[mode[num]] }.join
  end

  def resize_nlink(nlink)
      nlink.to_s.rjust(@list.max_nlink_width)
  end

  def resize_user(user)
     user.ljust(@list.max_user_width)
  end

  def resize_group(group)
    group.ljust(@list.max_group_width)
  end

  def resize_byte_size(size)
    size.to_s.rjust(@list.max_size_width)
  end

  def convert_modify_time(time)
    time.strftime('%_m %e %R')
  end
end
