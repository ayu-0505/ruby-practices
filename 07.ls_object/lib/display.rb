# frozen_string_literal: true

require_relative 'file_data'

class Display
  COLUMN_COUNT = 3
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
  end

  def render(long: false)
    if long
      long_list
    else
      width = max_base_name_width + SHORT_LIST_PADDING
      formated_files = @files.map { |file| file.base_name.ljust(width) }
      file_count = @files.count
      row_number = (file_count / COLUMN_COUNT.to_f).ceil
      (COLUMN_COUNT - (file_count % COLUMN_COUNT)).times { formated_files << '' } if file_count % COLUMN_COUNT != 0
      render_lines(formated_files, row_number)
    end
  end

  def long_list
    max_widths = find_max_widths
    total = "total #{@files.sum(&:blocks)}"
    render_files = @files.map { |file| build_data(file, max_widths) }.map { |file| format_row(file) }
    [total, render_files]
  end

  private

  def max_base_name_width
    @files.map { |file| file.base_name.size }.max
  end

  def render_lines(formated_files, row_number)
    render_lines = []
    formated_files.each_slice(row_number) { |file| render_lines << file }
    render_lines.transpose.map { |line| line.join.rstrip }.join("\n")
  end

  def find_max_widths
    {
      size: @files.map { |file| file.size.to_i }.max.to_s.size,
      nlink: @files.map { |file| file.nlink.to_i }.max.to_s.size,
      user: @files.map { |file| file.user_name.size }.max,
      group: @files.map { |file| file.group_name.size }.max
    }
  end

  def build_data(file, max_widths)
    {
      type: FILETYPES[file.type],
      mode: (-3..-1).map { |num| MODE_TABLE[file.mode[num]] }.join,
      nlink: file.nlink.to_s.rjust(max_widths[:nlink]),
      user: file.user_name.ljust(max_widths[:user]),
      group: file.group_name.ljust(max_widths[:group]),
      size: file.size.to_s.rjust(max_widths[:size]),
      mtime: file.mtime.strftime('%_m %e %R'),
      base_name: file.base_name
    }
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
