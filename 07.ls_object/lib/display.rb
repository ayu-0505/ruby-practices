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
      render_long_list
    else
      width = max_base_name_width + SHORT_LIST_PADDING
      formated_file_statuses = @file_statuses.map { |file| file.base_name.ljust(width) }
      file_count = @file_statuses.count
      row_count = (file_count / COLUMN_COUNT.to_f).ceil
      (COLUMN_COUNT - (file_count % COLUMN_COUNT)).times { formated_file_statuses << '' } if file_count % COLUMN_COUNT != 0
      render_short_list(formated_file_statuses, row_count)
    end
  end

  private

  def render_long_list
    max_widths = find_max_widths
    total = "total #{@file_statuses.sum(&:blocks)}"
    long_list = @file_statuses.map { |status| organize(status, max_widths) }.map { |organized_status| format_row(organized_status) }
    [total, long_list]
  end

  def max_base_name_width
    @file_statuses.map { |file| file.base_name.size }.max
  end

  def render_short_list(formated_file_statuses, row_number)
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

  def organize(status, max_widths)
    {
      type: FILETYPES[status.type],
      mode: (-3..-1).map { |num| MODE_TABLE[status.mode[num]] }.join,
      nlink: status.nlink.to_s.rjust(max_widths[:nlink]),
      user: status.user_name.ljust(max_widths[:user]),
      group: status.group_name.ljust(max_widths[:group]),
      size: status.size.to_s.rjust(max_widths[:size]),
      mtime: status.mtime.strftime('%_m %e %R'),
      base_name: status.base_name
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
