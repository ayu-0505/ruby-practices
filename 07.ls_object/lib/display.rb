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
    long ? render_long_list : render_short_list
  end

  private

  def render_long_list
    max_widths = find_max_widths
    total = "total #{@file_statuses.sum(&:blocks)}"
    long_list = @file_statuses.map { |status| format_file_status(status, max_widths) }
    [total, long_list]
  end

  def find_max_widths
    {
      size: @file_statuses.map { |file| file.size.to_i }.max.to_s.size,
      nlink: @file_statuses.map { |file| file.nlink.to_i }.max.to_s.size,
      user: @file_statuses.map { |file| file.user_name.size }.max,
      group: @file_statuses.map { |file| file.group_name.size }.max
    }
  end

  def format_file_status(status, max_widths)
    [
      FILETYPES[status.type],
      (-3..-1).map { |num| MODE_TABLE[status.mode[num]] }.join,
      "  #{status.nlink.to_s.rjust(max_widths[:nlink])}",
      " #{status.user_name.ljust(max_widths[:user])}",
      "  #{status.group_name.ljust(max_widths[:group])}",
      "  #{status.size.to_s.rjust(max_widths[:size])}",
      " #{status.mtime.strftime('%_m %e %R')}",
      " #{status.base_name}"
    ].join
  end

  def render_short_list
    width = max_base_name_width + SHORT_LIST_PADDING
    resized_base_names = @file_statuses.map { |file| file.base_name.ljust(width) }
    file_count = @file_statuses.count
    row_count = (file_count / COLUMN_COUNT.to_f).ceil
    (COLUMN_COUNT - (file_count % COLUMN_COUNT)).times { resized_base_names << '' } if file_count % COLUMN_COUNT != 0
    short_list_lines = []
    resized_base_names.each_slice(row_count) { |file| short_list_lines << file }
    short_list_lines.transpose.map { |line| line.join.rstrip }
  end

  def max_base_name_width
    @file_statuses.map { |file| file.base_name.size }.max
  end
end
