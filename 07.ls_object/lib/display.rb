# frozen_string_literal: true

require_relative 'file_status'

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
    @file_statuses = paths.map { |path| FileStatus.new(path) }
  end

  def render(long: false)
    if long
      long_list
    else
      width = max_base_name_width + SHORT_LIST_PADDING
      formated_file_statuses = @file_statuses.map { |file| file.path.ljust(width) }
      file_count = @file_statuses.count
      row_count = (file_count / COLUMN_COUNT.to_f).ceil
      (COLUMN_COUNT - (file_count % COLUMN_COUNT)).times { formated_file_statuses << '' } if file_count % COLUMN_COUNT != 0
      render_lines(formated_file_statuses, row_count)
    end
  end

  def long_list
    max_widths = find_max_widths
    total = "total #{@file_statuses.sum(&:blocks)}"
    render_file_statuses = @file_statuses.map { |file| build_data(file, max_widths) }.map { |file| format_row(file) }
    [total, render_file_statuses]
  end

  private

  def max_base_name_width
    @file_statuses.map { |file| file.path.size }.max
  end

  def render_lines(formated_file_statuses, row_number)
    render_lines = []
    formated_file_statuses.each_slice(row_number) { |file| render_lines << file }
    render_lines.transpose.map { |line| line.join.rstrip }.join("\n")
  end

  def find_max_widths
    {
      size: @file_statuses.map { |file| file.size.to_i }.max.to_s.size,
      nlink: @file_statuses.map { |file| file.nlink.to_i }.max.to_s.size,
      user: @file_statuses.map { |file| file.user_name.size }.max,
      group: @file_statuses.map { |file| file.group_name.size }.max
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
      path: file.path
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
      " #{data[:path]}"
    ].join
  end
end
